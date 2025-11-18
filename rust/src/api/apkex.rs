use apk_info::Apk;
use std::fs;
use std::path::Path;
use std::process::Command;


#[flutter_rust_bridge::frb] 
pub fn get_app_icon(apk_path: &str, delete_apk_after_processing: bool) -> Result<Vec<u8>, String> {
    let apk = Apk::new(apk_path)
        .map_err(|e| format!("Cannot open apk file: {}", e))?;
    let package_name = apk.get_package_name().unwrap_or_default();

    let  app_icon_path = apk.get_application_icon()
        .ok_or_else(|| "No application icon path found in APK".to_string())?;

    let (icon_data, _) = if app_icon_path.ends_with(".xml") {
        // Adaptive icon detected, search for a fallback PNG.
        println!("Adaptive icon detected. Searching for a fallback PNG icon.");
        const DENSITY_ORDER: &[&str] = &["xxxhdpi", "xxhdpi", "xhdpi", "hdpi", "mdpi"];

        DENSITY_ORDER.iter().find_map(|density| {
            let fallback_path = format!("res/mipmap-{}/ic_launcher.png", density);
            // Try to read the file; if it succeeds, we've found our icon.
            // If it fails (e.g., file not found), `ok()` turns the error into `None`
            // and `find_map` continues to the next density.
            apk.read(&fallback_path).ok()
        }).ok_or_else(|| "No suitable PNG fallback icon found for adaptive icon.".to_string())?
    } else {
        // The primary icon is not XML, so read it directly.
        apk.read(&app_icon_path)
            .map_err(|e| format!("Cannot read icon file '{}': {}", app_icon_path, e))?
    };
    
    // If the primary icon is an XML (adaptive icon), search for a fallback PNG.
    // Final check to ensure we are not sending XML data.
    if app_icon_path.ends_with(".xml") || icon_data.starts_with(b"<") {
        return Err("Icon is an XML adaptive icon, which is not supported.".to_string());
    }

    println!("Package name: {}", package_name);
    println!("Icon data extracted successfully.");

    if delete_apk_after_processing {
        fs::remove_file(apk_path)
            .map_err(|e| format!("Failed to delete APK file at {}: {}", apk_path, e))?;
        println!("APK file deleted: {}", apk_path);
    }

    Ok(icon_data.to_vec())
}

#[flutter_rust_bridge::frb]
pub fn pull_apk(adb_path: &str, device_id: &str, package_name: &str, output_dir_path: &str) -> Result<String, String> {
    // adb shell pm path com.example.app

    
    let devices_output = Command::new(adb_path)
    .arg("devices")
    .output()
    .map_err(|e| format!("Failed to execute adb devices command: {}", e))?;
    
    println!("Executing adb command: {:?}", devices_output);

    if devices_output.status.success() {
        println!("ADB Devices:\n{}", String::from_utf8_lossy(&devices_output.stdout));
    } else {
        println!("Could not get ADB devices: {}", String::from_utf8_lossy(&devices_output.stderr));
    }



    let mut path_command = Command::new(adb_path);
    path_command.args(["-s", device_id, "shell", "pm", "path", package_name]);

    println!("Executing adb command: {:?}", path_command);


    let path_output = path_command

        .output()
        .map_err(|e| format!("Failed to execute adb path command: {}", e))?;

    if !path_output.status.success() {
        let error_message = String::from_utf8_lossy(&path_output.stderr);
        return Err(format!("'adb shell pm path' failed: {}", error_message));
    }

    let remote_path_str = String::from_utf8(path_output.stdout)
        .map_err(|e| format!("Failed to read adb path command output: {}", e))?;

    let remote_paths: Vec<&str> = remote_path_str.trim().split("\n").collect();

    let remote_path = remote_paths
        .iter()
        .find(|path| path.contains("base.apk"))
        .map(|path| path.trim().strip_prefix("package:").unwrap_or(path.trim()))
        .unwrap_or_else(|| {
            remote_paths.first().map(|&path| path.trim().strip_prefix("package:").unwrap_or(path.trim())).expect("No APK paths found")
        });
    


    let mut pull_command = Command::new(adb_path);
    pull_command.args(["-s", device_id, "pull", remote_path, output_dir_path]);

    let pull_output = pull_command

        .output()
        .map_err(|e| format!("Failed to execute adb pull command: {}", e))?;

    if !pull_output.status.success() {
        let error_message = String::from_utf8_lossy(&pull_output.stderr);
        return Err(format!("'adb pull' failed: {}", error_message));
    }

    let original_apk_name = Path::new(remote_path)
        .file_name()
        .ok_or_else(|| "Could not determine APK file name".to_string())?
        .to_str().ok_or_else(|| "Invalid file name".to_string())?;

    let original_path = Path::new(output_dir_path).join(original_apk_name);
    let new_apk_name = format!("{}.apk", package_name);
    let new_path = Path::new(output_dir_path).join(&new_apk_name);

    fs::rename(&original_path, &new_path).map_err(|e| format!("Failed to rename APK: {}", e))?;

    Ok(new_path.to_string_lossy().into_owned())
}
