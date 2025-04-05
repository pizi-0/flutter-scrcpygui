import 'package:shadcn_flutter/shadcn_flutter.dart';

class Select<T> extends StatefulWidget with SelectBase<T> {
  static const kDefaultSelectMaxHeight = 240.0;
  @override
  final ValueChanged<T?>? onChanged; // if null, then it's a disabled combobox
  @override
  final Widget? placeholder; // placeholder when value is null
  @override
  final bool filled;
  @override
  final FocusNode? focusNode;
  @override
  final BoxConstraints? constraints;
  @override
  final BoxConstraints? popupConstraints;
  @override
  final PopoverConstraint popupWidthConstraint;
  final T? value;
  @override
  final BorderRadiusGeometry? borderRadius;
  @override
  final EdgeInsetsGeometry? padding;
  @override
  final AlignmentGeometry popoverAlignment;
  @override
  final AlignmentGeometry? popoverAnchorAlignment;
  @override
  final bool disableHoverEffect;
  @override
  final bool canUnselect;
  @override
  final bool? autoClosePopover;
  final bool? enabled;
  @override
  final SelectPopupBuilder popup;
  @override
  final SelectValueBuilder<T> itemBuilder;
  @override
  final SelectValueSelectionHandler<T>? valueSelectionHandler;
  @override
  final SelectValueSelectionPredicate<T>? valueSelectionPredicate;
  @override
  final Predicate<T>? showValuePredicate;

  const Select({
    super.key,
    this.onChanged,
    this.placeholder,
    this.filled = false,
    this.focusNode,
    this.constraints,
    this.popupConstraints,
    this.popupWidthConstraint = PopoverConstraint.anchorFixedSize,
    this.value,
    this.disableHoverEffect = false,
    this.borderRadius,
    this.padding,
    this.popoverAlignment = Alignment.topCenter,
    this.popoverAnchorAlignment,
    this.canUnselect = false,
    this.autoClosePopover = true,
    this.enabled,
    this.valueSelectionHandler,
    this.valueSelectionPredicate,
    this.showValuePredicate,
    required this.popup,
    required this.itemBuilder,
  });

  @override
  SelectState<T> createState() => SelectState<T>();
}

class SelectState<T> extends State<Select<T>>
    with FormValueSupplier<T, Select<T>> {
  late FocusNode _focusNode;
  final PopoverController _popoverController = PopoverController();
  late ValueNotifier<T?> _valueNotifier;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _valueNotifier = ValueNotifier(widget.value);
    formValue = widget.value;
  }

  @override
  void didUpdateWidget(Select<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _valueNotifier.value = widget.value;
      });
      formValue = widget.value;
    } else if (widget.valueSelectionPredicate !=
        oldWidget.valueSelectionPredicate) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _valueNotifier.value = widget.value;
      });
    }
    if (widget.enabled != oldWidget.enabled ||
        widget.onChanged != oldWidget.onChanged) {
      bool enabled = widget.enabled ?? widget.onChanged != null;
      if (!enabled) {
        _focusNode.unfocus();
        _popoverController.close();
      }
    }
  }

  Widget get _placeholder {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }
    return const SizedBox();
  }

  @override
  void didReplaceFormValue(T value) {
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  closePopup() {
    _popoverController.close();
  }

  BoxDecoration _overrideBorderRadius(
      BuildContext context, Set<WidgetState> states, Decoration value) {
    return (value as BoxDecoration).copyWith(
      borderRadius: widget.borderRadius,
    );
  }

  EdgeInsetsGeometry _overridePadding(
      BuildContext context, Set<WidgetState> states, EdgeInsetsGeometry value) {
    return widget.padding!;
  }

  bool _onChanged(Object? value, bool selected) {
    if (!selected && !widget.canUnselect) {
      return false;
    }
    var selectionHandler = widget.valueSelectionHandler ??
        _defaultSingleSelectValueSelectionHandler;
    var newValue = selectionHandler(widget.value, value, selected);
    widget.onChanged?.call(newValue);
    return true;
  }

  bool _isSelected(Object? value) {
    final selectionPredicate = widget.valueSelectionPredicate ??
        _defaultSingleSelectValueSelectionPredicate;
    return selectionPredicate(widget.value, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    var enabled = widget.enabled ?? widget.onChanged != null;
    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: widget.constraints ?? const BoxConstraints(),
        child: TapRegion(
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          child: Button(
            enabled: enabled,
            disableHoverEffect: widget.disableHoverEffect,
            focusNode: _focusNode,
            style: (widget.filled
                    ? ButtonVariance.secondary
                    : ButtonVariance.outline)
                .copyWith(
              decoration:
                  widget.borderRadius != null ? _overrideBorderRadius : null,
              padding: widget.padding != null ? _overridePadding : null,
            ),
            onPressed: widget.onChanged == null
                ? null
                : () {
                    // to prevent entire ListView from rebuilding
                    // while the Data<SelectData> is being updated
                    GlobalKey popupKey = GlobalKey();
                    _popoverController
                        .show(
                      context: context,
                      offset: Offset(0, 8 * scaling),
                      alignment: widget.popoverAlignment,
                      anchorAlignment: widget.popoverAnchorAlignment,
                      widthConstraint: widget.popupWidthConstraint,
                      overlayBarrier: OverlayBarrier(
                        padding:
                            const EdgeInsets.symmetric(vertical: 8) * scaling,
                        borderRadius: BorderRadius.circular(theme.radiusLg),
                      ),
                      builder: (context) {
                        return ConstrainedBox(
                          constraints: widget.popupConstraints ??
                              BoxConstraints(
                                maxHeight:
                                    Select.kDefaultSelectMaxHeight * scaling,
                              ),
                          child: ListenableBuilder(
                              listenable: _valueNotifier,
                              builder: (context, _) {
                                return Data.inherit(
                                  key: ValueKey(widget.value),
                                  data: SelectData(
                                    enabled: enabled,
                                    autoClose: widget.autoClosePopover,
                                    isSelected: _isSelected,
                                    onChanged: _onChanged,
                                    hasSelection: widget.value != null,
                                  ),
                                  child: Builder(
                                      key: popupKey,
                                      builder: (context) {
                                        return widget.popup(context);
                                      }),
                                );
                              }),
                        );
                      },
                    )
                        .then(
                      (value) {
                        _focusNode.requestFocus();
                      },
                    );
                  },
            child: WidgetStatesProvider.boundary(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Data.inherit(
                    data: SelectData(
                      enabled: enabled,
                      autoClose: widget.autoClosePopover,
                      isSelected: _isSelected,
                      onChanged: _onChanged,
                      hasSelection: widget.value != null,
                    ),
                    child: Expanded(
                      child: widget.value != null &&
                              (widget.showValuePredicate
                                      ?.call(widget.value as T) ??
                                  true)
                          ? Builder(builder: (context) {
                              return widget.itemBuilder(
                                context,
                                widget.value as T,
                              );
                            })
                          : _placeholder,
                    ),
                  ),
                  SizedBox(width: 8 * scaling),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: theme.colorScheme.foreground,
                      opacity: 0.5,
                    ),
                    child: const Icon(LucideIcons.chevronsUpDown).iconSmall(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

T? _defaultSingleSelectValueSelectionHandler<T>(
    T? oldValue, Object? value, bool selected) {
  if (value is! T?) {
    return null;
  }
  return selected ? value : null;
}

bool _defaultSingleSelectValueSelectionPredicate<T>(T? value, Object? test) {
  return value == test;
}
