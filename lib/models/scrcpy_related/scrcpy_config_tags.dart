enum ConfigTag {
  defaultConfig('default'),
  customConfig('custom'),
  recording('rec'),
  mirror('mir'),
  videoOnly('vid'),
  audioOnly('aud'),
  virtualDisplay('virt'),
  withApp('app');

  final String label;
  const ConfigTag(this.label);
}
