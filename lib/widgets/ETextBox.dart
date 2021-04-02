import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// class EtTextBox extends TextField {
//
//   @override
//   _EtTextBoxState createState() => _EtTextBoxState();
//
//   EtTextBox(double width,
//       double height,
//       {
//         //Color? borderColor
//       }) : super(
//     style: TextStyle(
//       color: Color(0xffb1bfca),
//       fontSize: 18,
//       fontFamily: 'Source Han Sans SC',
//       fontWeight: FontWeight.w300,
//       //...
//     ),
//     obscuringCharacter: '⚫', // or not,
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//           borderSide: BorderSide(
//               width: 2,
//               color: Colors.grey
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(height / 2)),
//           gapPadding: height / 1.6 //TODO: figure out how it should be set
//       ),
//
//       /// Error
//       errorStyle: TextStyle(
//         color: Color(0xffff6666),
//         fontWeight: FontWeight.w500,
//         fontSize: 14,
//       ),
//       errorText: null,
//       prefix: SizedBox(width: height / 4),
//
//       /// Focused
//       focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             width: 2,
//             color: Colors.green,
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(height / 2)),
//           gapPadding: height / 1.6 //TODO: figure out how it should be set
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//               width: 2,
//               color: Colors.redAccent
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(height / 2)),
//           gapPadding: height / 1.6 //TODO: figure out how it should be set
//       ),
//
//     ),
//   ) {
//   }
//
// }
//
// class _EtTextBoxState extends State<EtTextBox>
//     with RestorationMixin
//     implements TextSelectionGestureDetectorBuilderDelegate {
//   RestorableTextEditingController? _controller;
//
//   TextEditingController get _effectiveController =>
//       widget.controller ?? _controller!.value;
//
//   FocusNode? _focusNode;
//
//   FocusNode get _effectiveFocusNode =>
//       widget.focusNode ?? (_focusNode ??= FocusNode());
//
//   MaxLengthEnforcement get _effectiveMaxLengthEnforcement =>
//       widget.maxLengthEnforcement
//           ??
//           LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement(Theme
//               .of(context)
//               .platform);
//
//   bool _isHovering = false;
//
//   bool get needsCounter =>
//       widget.maxLength != null
//           && widget.decoration != null
//           && widget.decoration!.counterText == null;
//
//   bool _showSelectionHandles = false;
//
//   late _TextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;
//
//   // API for TextSelectionGestureDetectorBuilderDelegate.
//   @override
//   late bool forcePressEnabled;
//
//   @override
//   final GlobalKey<EditableTextState> editableTextKey = GlobalKey<
//       EditableTextState>();
//
//   @override
//   bool get selectionEnabled => widget.selectionEnabled;
//
//   // End of API for TextSelectionGestureDetectorBuilderDelegate.
//
//   bool get _isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;
//
//   int get _currentLength => _effectiveController.value.text.characters.length;
//
//   bool get _hasIntrinsicError =>
//       widget.maxLength != null && widget.maxLength! > 0 &&
//           _effectiveController.value.text.characters.length > widget.maxLength!;
//
//   bool get _hasError =>
//       widget.decoration?.errorText != null || _hasIntrinsicError;
//
//   InputDecoration _getEffectiveDecoration() {
//     final MaterialLocalizations localizations = MaterialLocalizations.of(
//         context);
//     final ThemeData themeData = Theme.of(context);
//     final InputDecoration effectiveDecoration = (widget.decoration ??
//         const InputDecoration())
//         .applyDefaults(themeData.inputDecorationTheme)
//         .copyWith(
//       enabled: _isEnabled,
//       hintMaxLines: widget.decoration?.hintMaxLines ?? widget.maxLines,
//     );
//
//     // No need to build anything if counter or counterText were given directly.
//     if (effectiveDecoration.counter != null ||
//         effectiveDecoration.counterText != null)
//       return effectiveDecoration;
//
//     // If buildCounter was provided, use it to generate a counter widget.
//     Widget? counter;
//     final int currentLength = _currentLength;
//     if (effectiveDecoration.counter == null
//         && effectiveDecoration.counterText == null
//         && widget.buildCounter != null) {
//       final bool isFocused = _effectiveFocusNode.hasFocus;
//       final Widget? builtCounter = widget.buildCounter!(
//         context,
//         currentLength: currentLength,
//         maxLength: widget.maxLength,
//         isFocused: isFocused,
//       );
//       // If buildCounter returns null, don't add a counter widget to the field.
//       if (builtCounter != null) {
//         counter = Semantics(
//           container: true,
//           liveRegion: isFocused,
//           child: builtCounter,
//         );
//       }
//       return effectiveDecoration.copyWith(counter: counter);
//     }
//
//     if (widget.maxLength == null)
//       return effectiveDecoration; // No counter widget
//
//     String counterText = '$currentLength';
//     String semanticCounterText = '';
//
//     // Handle a real maxLength (positive number)
//     if (widget.maxLength! > 0) {
//       // Show the maxLength in the counter
//       counterText += '/${widget.maxLength}';
//       final int remaining = (widget.maxLength! - currentLength).clamp(
//           0, widget.maxLength!);
//       semanticCounterText =
//           localizations.remainingTextFieldCharacterCount(remaining);
//     }
//
//     if (_hasIntrinsicError) {
//       return effectiveDecoration.copyWith(
//         errorText: effectiveDecoration.errorText ?? '',
//         counterStyle: effectiveDecoration.errorStyle
//             ??
//             themeData.textTheme.caption!.copyWith(color: themeData.errorColor),
//         counterText: counterText,
//         semanticCounterText: semanticCounterText,
//       );
//     }
//
//     return effectiveDecoration.copyWith(
//       counterText: counterText,
//       semanticCounterText: semanticCounterText,
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _selectionGestureDetectorBuilder =
//         _TextFieldSelectionGestureDetectorBuilder(state: this);
//     if (widget.controller == null) {
//       _createLocalController();
//     }
//     _effectiveFocusNode.canRequestFocus = _isEnabled;
//   }
//
//   bool get _canRequestFocus {
//     final NavigationMode mode = MediaQuery
//         .maybeOf(context)
//         ?.navigationMode ?? NavigationMode.traditional;
//     switch (mode) {
//       case NavigationMode.traditional:
//         return _isEnabled;
//       case NavigationMode.directional:
//         return true;
//     }
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _effectiveFocusNode.canRequestFocus = _canRequestFocus;
//   }
//
//   @override
//   void didUpdateWidget(EtTextBox oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.controller == null && oldWidget.controller != null) {
//       _createLocalController(oldWidget.controller!.value);
//     } else if (widget.controller != null && oldWidget.controller == null) {
//       unregisterFromRestoration(_controller!);
//       _controller!.dispose();
//       _controller = null;
//     }
//     _effectiveFocusNode.canRequestFocus = _canRequestFocus;
//     if (_effectiveFocusNode.hasFocus && widget.readOnly != oldWidget.readOnly &&
//         _isEnabled) {
//       if (_effectiveController.selection.isCollapsed) {
//         _showSelectionHandles = !widget.readOnly;
//       }
//     }
//   }
//
//   @override
//   void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
//     if (_controller != null) {
//       _registerController();
//     }
//   }
//
//   void _registerController() {
//     assert(_controller != null);
//     registerForRestoration(_controller!, 'controller');
//   }
//
//   void _createLocalController([TextEditingValue? value]) {
//     assert(_controller == null);
//     _controller = value == null
//         ? RestorableTextEditingController()
//         : RestorableTextEditingController.fromValue(value);
//     if (!restorePending) {
//       _registerController();
//     }
//   }
//
//   @override
//   String? get restorationId => widget.restorationId;
//
//   @override
//   void dispose() {
//     _focusNode?.dispose();
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   EditableTextState? get _editableText => editableTextKey.currentState;
//
//   void _requestKeyboard() {
//     _editableText?.requestKeyboard();
//   }
//
//   bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
//     // When the text field is activated by something that doesn't trigger the
//     // selection overlay, we shouldn't show the handles either.
//     if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar)
//       return false;
//
//     if (cause == SelectionChangedCause.keyboard)
//       return false;
//
//     if (widget.readOnly && _effectiveController.selection.isCollapsed)
//       return false;
//
//     if (!_isEnabled)
//       return false;
//
//     if (cause == SelectionChangedCause.longPress)
//       return true;
//
//     if (_effectiveController.text.isNotEmpty)
//       return true;
//
//     return false;
//   }
//
//   void _handleSelectionChanged(TextSelection selection,
//       SelectionChangedCause? cause) {
//     final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
//     if (willShowSelectionHandles != _showSelectionHandles) {
//       setState(() {
//         _showSelectionHandles = willShowSelectionHandles;
//       });
//     }
//
//     switch (Theme
//         .of(context)
//         .platform) {
//       case TargetPlatform.iOS:
//       case TargetPlatform.macOS:
//         if (cause == SelectionChangedCause.longPress) {
//           _editableText?.bringIntoView(selection.base);
//         }
//         return;
//       case TargetPlatform.android:
//       case TargetPlatform.fuchsia:
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//       // Do nothing.
//     }
//   }
//
//   /// Toggle the toolbar when a selection handle is tapped.
//   void _handleSelectionHandleTapped() {
//     if (_effectiveController.selection.isCollapsed) {
//       _editableText!.toggleToolbar();
//     }
//   }
//
//   void _handleHover(bool hovering) {
//     if (hovering != _isHovering) {
//       setState(() {
//         _isHovering = hovering;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     assert(debugCheckHasMaterial(context));
//     assert(debugCheckHasMaterialLocalizations(context));
//     assert(debugCheckHasDirectionality(context));
//     assert(
//     !(widget.style != null && widget.style!.inherit == false &&
//         (widget.style!.fontSize == null || widget.style!.textBaseline == null)),
//     'inherit false style must supply fontSize and textBaseline',
//     );
//
//     final ThemeData theme = Theme.of(context);
//     final TextSelectionThemeData selectionTheme = TextSelectionTheme.of(
//         context);
//     final TextStyle style = theme.textTheme.subtitle1!.merge(widget.style);
//     final Brightness keyboardAppearance = widget.keyboardAppearance ??
//         theme.primaryColorBrightness;
//     final TextEditingController controller = _effectiveController;
//     final FocusNode focusNode = _effectiveFocusNode;
//     final List<TextInputFormatter> formatters = <TextInputFormatter>[
//       ...?widget.inputFormatters,
//       if (widget.maxLength != null && widget.maxLengthEnforced)
//         LengthLimitingTextInputFormatter(
//           widget.maxLength,
//           maxLengthEnforcement: _effectiveMaxLengthEnforcement,
//         ),
//     ];
//
//     TextSelectionControls? textSelectionControls = widget.selectionControls;
//     final bool paintCursorAboveText;
//     final bool cursorOpacityAnimates;
//     Offset? cursorOffset;
//     Color? cursorColor = widget.cursorColor;
//     final Color selectionColor;
//     Color? autocorrectionTextRectColor;
//     Radius? cursorRadius = widget.cursorRadius;
//
//     switch (theme.platform) {
//       case TargetPlatform.iOS:
//         final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
//         forcePressEnabled = true;
//         textSelectionControls ??= cupertinoTextSelectionControls;
//         paintCursorAboveText = true;
//         cursorOpacityAnimates = true;
//         cursorColor ??=
//             selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
//         selectionColor = selectionTheme.selectionColor ??
//             cupertinoTheme.primaryColor.withOpacity(0.40);
//         cursorRadius ??= const Radius.circular(2.0);
//         cursorOffset = Offset(iOSHorizontalOffset / MediaQuery
//             .of(context)
//             .devicePixelRatio, 0);
//         autocorrectionTextRectColor = selectionColor;
//         break;
//
//       case TargetPlatform.macOS:
//         final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
//         forcePressEnabled = false;
//         textSelectionControls ??= cupertinoDesktopTextSelectionControls;
//         paintCursorAboveText = true;
//         cursorOpacityAnimates = true;
//         cursorColor ??=
//             selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
//         selectionColor = selectionTheme.selectionColor ??
//             cupertinoTheme.primaryColor.withOpacity(0.40);
//         cursorRadius ??= const Radius.circular(2.0);
//         cursorOffset = Offset(iOSHorizontalOffset / MediaQuery
//             .of(context)
//             .devicePixelRatio, 0);
//         break;
//
//       case TargetPlatform.android:
//       case TargetPlatform.fuchsia:
//         forcePressEnabled = false;
//         textSelectionControls ??= materialTextSelectionControls;
//         paintCursorAboveText = false;
//         cursorOpacityAnimates = false;
//         cursorColor ??= selectionTheme.cursorColor ?? theme.colorScheme.primary;
//         selectionColor = selectionTheme.selectionColor ??
//             theme.colorScheme.primary.withOpacity(0.40);
//         break;
//
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//         forcePressEnabled = false;
//         textSelectionControls ??= desktopTextSelectionControls;
//         paintCursorAboveText = false;
//         cursorOpacityAnimates = false;
//         cursorColor ??= selectionTheme.cursorColor ?? theme.colorScheme.primary;
//         selectionColor = selectionTheme.selectionColor ??
//             theme.colorScheme.primary.withOpacity(0.40);
//         break;
//     }
//
//     Widget child = RepaintBoundary(
//       child: UnmanagedRestorationScope(
//         bucket: bucket,
//         child: EditableText(
//           key: editableTextKey,
//           readOnly: widget.readOnly || !_isEnabled,
//           toolbarOptions: widget.toolbarOptions,
//           showCursor: widget.showCursor,
//           showSelectionHandles: _showSelectionHandles,
//           controller: controller,
//           focusNode: focusNode,
//           keyboardType: widget.keyboardType,
//           textInputAction: widget.textInputAction,
//           textCapitalization: widget.textCapitalization,
//           style: style,
//           strutStyle: widget.strutStyle,
//           textAlign: widget.textAlign,
//           textDirection: widget.textDirection,
//           autofocus: widget.autofocus,
//           obscuringCharacter: widget.obscuringCharacter,
//           obscureText: widget.obscureText,
//           autocorrect: widget.autocorrect,
//           smartDashesType: widget.smartDashesType,
//           smartQuotesType: widget.smartQuotesType,
//           enableSuggestions: widget.enableSuggestions,
//           maxLines: widget.maxLines,
//           minLines: widget.minLines,
//           expands: widget.expands,
//           selectionColor: selectionColor,
//           selectionControls: widget.selectionEnabled
//               ? textSelectionControls
//               : null,
//           onChanged: widget.onChanged,
//           onSelectionChanged: _handleSelectionChanged,
//           onEditingComplete: widget.onEditingComplete,
//           onSubmitted: widget.onSubmitted,
//           onAppPrivateCommand: widget.onAppPrivateCommand,
//           onSelectionHandleTapped: _handleSelectionHandleTapped,
//           inputFormatters: formatters,
//           rendererIgnoresPointer: true,
//           mouseCursor: MouseCursor.defer,
//           // TextField will handle the cursor
//           cursorWidth: widget.cursorWidth,
//           cursorHeight: widget.cursorHeight,
//           cursorRadius: cursorRadius,
//           cursorColor: cursorColor,
//           selectionHeightStyle: widget.selectionHeightStyle,
//           selectionWidthStyle: widget.selectionWidthStyle,
//           cursorOpacityAnimates: cursorOpacityAnimates,
//           cursorOffset: cursorOffset,
//           paintCursorAboveText: paintCursorAboveText,
//           backgroundCursorColor: CupertinoColors.inactiveGray,
//           scrollPadding: widget.scrollPadding,
//           keyboardAppearance: keyboardAppearance,
//           enableInteractiveSelection: widget.enableInteractiveSelection,
//           dragStartBehavior: widget.dragStartBehavior,
//           scrollController: widget.scrollController,
//           scrollPhysics: widget.scrollPhysics,
//           autofillHints: widget.autofillHints,
//           autocorrectionTextRectColor: autocorrectionTextRectColor,
//           restorationId: 'editable',
//         ),
//       ),
//     );
//
//     if (widget.decoration != null) {
//       child = AnimatedBuilder(
//         animation: Listenable.merge(<Listenable>[ focusNode, controller]),
//         builder: (BuildContext context, Widget? child) {
//           return InputDecorator(
//             decoration: _getEffectiveDecoration(),
//             baseStyle: widget.style,
//             textAlign: widget.textAlign,
//             textAlignVertical: widget.textAlignVertical,
//             isHovering: _isHovering,
//             isFocused: focusNode.hasFocus,
//             isEmpty: controller.value.text.isEmpty,
//             expands: widget.expands,
//             child: child,
//           );
//         },
//         child: child,
//       );
//     }
//     final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<
//         MouseCursor>(
//       widget.mouseCursor ?? MaterialStateMouseCursor.textable,
//       <MaterialState>{
//         if (!_isEnabled) MaterialState.disabled,
//         if (_isHovering) MaterialState.hovered,
//         if (focusNode.hasFocus) MaterialState.focused,
//         if (_hasError) MaterialState.error,
//       },
//     );
//
//     final int? semanticsMaxValueLength;
//     if (widget.maxLengthEnforced &&
//         _effectiveMaxLengthEnforcement != MaxLengthEnforcement.none &&
//         widget.maxLength != null &&
//         widget.maxLength! > 0) {
//       semanticsMaxValueLength = widget.maxLength;
//     } else {
//       semanticsMaxValueLength = null;
//     }
//
//     child = MouseRegion(
//       cursor: effectiveMouseCursor,
//       onEnter: (PointerEnterEvent event) => _handleHover(true),
//       onExit: (PointerExitEvent event) => _handleHover(false),
//       child: IgnorePointer(
//         ignoring: !_isEnabled,
//         child: AnimatedBuilder(
//           animation: controller, // changes the _currentLength
//           builder: (BuildContext context, Widget? child) {
//             return Semantics(
//               maxValueLength: semanticsMaxValueLength,
//               currentValueLength: _currentLength,
//               onTap: widget.readOnly ? null : () {
//                 if (!_effectiveController.selection.isValid)
//                   _effectiveController.selection = TextSelection.collapsed(
//                       offset: _effectiveController.text.length);
//                 _requestKeyboard();
//               },
//               child: child,
//             );
//           },
//           child: _selectionGestureDetectorBuilder.buildGestureDetector(
//             behavior: HitTestBehavior.translucent,
//             child: child,
//           ),
//         ),
//       ),
//     );
//
//     if (kIsWeb) {
//       return Shortcuts(
//         shortcuts: scrollShortcutOverrides,
//         child: child,
//       );
//     }
//     return child;
//   }
// }
//
// StatefulWidget? getTextBox({TextEditingController? controller,}) {
//   //       focusedBorder: OutlineInputBorder(
//   //           borderSide: BorderSide(
//   //             width: 2,
//   //             color: Colors.blueAccent,
//   //           ),
//   //           borderRadius:
//   //           BorderRadius.all(Radius.circular(widget.height / 2)),
//   //           gapPadding: widget.height / 1.6),
//   //       enabledBorder: OutlineInputBorder(
//   //           borderSide: BorderSide(
//   //             width: 2,
//   //             color: Colors.blueGrey,
//   //           ),
//   //           borderRadius:
//   //           BorderRadius.all(Radius.circular(widget.height / 2)),
//   //           gapPadding: widget.height / 2)),
//   // )
// }
//
//
// class _TextFieldSelectionGestureDetectorBuilder
//     extends TextSelectionGestureDetectorBuilder {
//   _TextFieldSelectionGestureDetectorBuilder({
//     required _EtTextBoxState state,
//   })
//       : _state = state,
//         super(delegate: state);
//
//   final _EtTextBoxState _state;
//
//   @override
//   void onForcePressStart(ForcePressDetails details) {
//     super.onForcePressStart(details);
//     if (delegate.selectionEnabled && shouldShowSelectionToolbar) {
//       editableText.showToolbar();
//     }
//   }
//
//   @override
//   void onForcePressEnd(ForcePressDetails details) {
//     // Not required.
//   }
//
//   @override
//   void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
//     if (delegate.selectionEnabled) {
//       switch (Theme
//           .of(_state.context)
//           .platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           renderEditable.selectPositionAt(
//             from: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           renderEditable.selectWordsInRange(
//             from: details.globalPosition - details.offsetFromOrigin,
//             to: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//       }
//     }
//   }
//
//   @override
//   void onSingleTapUp(TapUpDetails details) {
//     editableText.hideToolbar();
//     if (delegate.selectionEnabled) {
//       switch (Theme
//           .of(_state.context)
//           .platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           switch (details.kind) {
//             case PointerDeviceKind.mouse:
//             case PointerDeviceKind.stylus:
//             case PointerDeviceKind.invertedStylus:
//             // Precise devices should place the cursor at a precise position.
//               renderEditable.selectPosition(cause: SelectionChangedCause.tap);
//               break;
//             case PointerDeviceKind.touch:
//             case PointerDeviceKind.unknown:
//             // On macOS/iOS/iPadOS a touch tap places the cursor at the edge
//             // of the word.
//               renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
//               break;
//           }
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           renderEditable.selectPosition(cause: SelectionChangedCause.tap);
//           break;
//       }
//     }
//     _state._requestKeyboard();
//     if (_state.widget.onTap != null)
//       _state.widget.onTap!();
//   }
//
//   @override
//   void onSingleLongTapStart(LongPressStartDetails details) {
//     if (delegate.selectionEnabled) {
//       switch (Theme
//           .of(_state.context)
//           .platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           renderEditable.selectPositionAt(
//             from: details.globalPosition,
//             cause: SelectionChangedCause.longPress,
//           );
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           renderEditable.selectWord(cause: SelectionChangedCause.longPress);
//           Feedback.forLongPress(_state.context);
//           break;
//       }
//     }
//   }
