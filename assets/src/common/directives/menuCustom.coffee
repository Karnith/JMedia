class App extends App('menuCustom')
  constructor: ->
    return []
class menuCustom extends Directive('menuCustom')
  constructor: ->
    return {
      restrict: 'A'
      link: customMods
    }
    customMods = ($scope, $window, $document)->
      window = $scope.$window = $window
      public_vars = public_vars or {}
      angular.element document
      .ready ->
        # Sidebar Menu var
        public_vars.$body = $ "body"
        public_vars.$pageContainer = public_vars.$body.find ".page-container"
        public_vars.$chat = public_vars.$pageContainer.find "#chat"
        public_vars.$horizontalMenu = public_vars.$pageContainer.find "header.navbar"
        public_vars.$sidebarMenu = public_vars.$pageContainer.find ".sidebar-menu"
        public_vars.$mainMenu = public_vars.$sidebarMenu.find "#main-menu"
        public_vars.$mainContent = public_vars.$pageContainer.find ".main-content"
        public_vars.$sidebarUserEnv = public_vars.$sidebarMenu.find ".sidebar-user-info"
        public_vars.$sidebarUser = public_vars.$sidebarUserEnv.find ".user-link"
        public_vars.$body.addClass "loaded"
        # Just to make sure...
        window
        .on "error", (ev) ->
          # Do not let page without showing if JS fails somewhere
          init_page_transitions()
          return
        public_vars.isRightSidebar = true  if public_vars.$pageContainer.hasClass "right-sidebar"
        # Sidebar Menu Setup
        setup_sidebar_menu()
        # Horizontal Menu Setup
        setup_horizontal_menu()
        # Sidebar Collapse icon
        public_vars.$sidebarMenu.find ".sidebar-collapse-icon"
        .on "click", (ev) ->
          ev.preventDefault()
          with_animation = $ this
          .hasClass "with-animation"
          toggle_sidebar_menu with_animation
          return
        # Mobile Sidebar Collapse icon
        public_vars.$sidebarMenu.find ".sidebar-mobile-menu a"
        .on "click", (ev) ->
          ev.preventDefault()
          with_animation = $ this
          .hasClass "with-animation"
          if with_animation
            public_vars.$mainMenu.stop().slideToggle "normal", ->
              public_vars.$mainMenu.css "height", "auto"
              return
          else
            public_vars.$mainMenu.toggle()
          return
        # Mobile Horizontal Menu Collapse icon
        public_vars.$horizontalMenu.find ".horizontal-mobile-menu a"
        .on "click", (ev) ->
          ev.preventDefault()
          $menu = public_vars.$horizontalMenu.find ".navbar-nav"
          with_animation = $ this
          .hasClass "with-animation"
          if with_animation
            $menu.stop().slideToggle "normal", ->
              $menu.attr "height", "auto"
              $menu.attr "style", ""  if $menu.css "display" is "none"
              return
          else
            $menu.toggle()
          return
        # Close Sidebar if Tablet Screen is visible
        public_vars.$sidebarMenu.data "initial-state", (if public_vars.$pageContainer.hasClass("sidebar-collapsed") then "closed" else "open")
        hide_sidebar_menu false if is_("tabletscreen")
        # NiceScroll
        if $.isFunction $.fn.niceScroll
          nicescroll_defaults =
            cursorcolor: "#d4d4d4"
            cursorborder: "1px solid #ccc"
            railpadding:
              right: 3
            cursorborderradius: 1
            autohidemode: true
            sensitiverail: true
          public_vars.$body.find ".dropdown .scroller"
          .niceScroll nicescroll_defaults
          $ ".dropdown"
          .on "shown.bs.dropdown", ->
            $ ".scroller"
            .getNiceScroll().resize()
            $ ".scroller"
            .getNiceScroll().show()
            return
          fixed_sidebar = $ ".sidebar-menu.fixed"
          if fixed_sidebar.length is 1
            fs_tm = 0
            fixed_sidebar.niceScroll
              cursorcolor: "#454a54"
              cursorborder: "1px solid #454a54"
              railpadding:
                right: 3
              railalign: "right"
              cursorborderradius: 1
            fixed_sidebar.on "click", "li a", ->
              fixed_sidebar.getNiceScroll().resize()
              fixed_sidebar.getNiceScroll().show()
              window.clearTimeout fs_tm
              fs_tm = setTimeout(->
                fixed_sidebar.getNiceScroll().resize()
                return
              , 500)
              return
        # Scrollable
        if $.isFunction $.fn.slimScroll
          $ ".scrollable"
          .each (i, el) ->
            $this = $ el
            height = attrDefault $this, "height", $this.height()
            if $this.is ":visible"
              $this.removeClass "scrollable"
              height = $this.outerHeight true + 10  if $this.height() < parseInt(height, 10)
              $this.addClass "scrollable"
            $this.css maxHeight: ""
            .slimScroll
                height: height
                position: attrDefault $this, "scroll-position", "right"
                color: attrDefault $this, "rail-color", "#000"
                size: attrDefault $this, "rail-width", 6
                borderRadius: attrDefault $this, "rail-radius", 3
                opacity: attrDefault $this, "rail-opacity", .3
                alwaysVisible: if parseInt(attrDefault($this, "autohide", 1), 10) is 1 then false else true
            return
        # Panels
        # Added on v1.1.4 - Fixed collapsing effect with panel tables
        $ ".panel-heading"
        .each (i, el) ->
          $this = $ el
          $body = $this.next "table"
          $body.wrap "<div class=\"panel-body with-table\"></div>"
          $body = $this.next ".with-table"
          .next "table"
          $body.wrap "<div class=\"panel-body with-table\"></div>"
          return
        continueWrappingPanelTables()
        # End of: Added on v1.1.4
        $ "body"
        .on "click", ".panel > .panel-heading > .panel-options > a[data-rel=\"reload\"]", (ev) ->
          ev.preventDefault()
          $this = jQuery this
          .closest ".panel"
          blockUI $this
          $this.addClass "reloading"
          setTimeout ->
            unblockUI $this
            $this.removeClass "reloading"
            return
          , 900
          return
        .on "click", ".panel > .panel-heading > .panel-options > a[data-rel=\"close\"]", (ev) ->
          ev.preventDefault()
          $this = $ this
          $panel = $this.closest ".panel"
          t = new TimelineLite onComplete: ->
            $panel.slideUp ->
              $panel.remove()
              return
            return
          t.append TweenMax.to $panel, .2,
            css:
              scale: 0.95
          t.append TweenMax.to $panel, .5,
            css:
              autoAlpha: 0
              transform: "translateX(100px) scale(.95)"
          return
        .on "click", ".panel > .panel-heading > .panel-options > a[data-rel=\"collapse\"]", (ev) ->
          ev.preventDefault()
          $this = $ this
          $panel = $this.closest ".panel"
          $body = $panel.children ".panel-body, .table"
          do_collapse = not $panel.hasClass "panel-collapse"
          if $panel.is "[data-collapsed=\"1\"]"
            $panel.attr "data-collapsed", 0
            $body.hide()
            do_collapse = false
          if do_collapse
            $body.slideUp "normal", fit_main_content_height
            $panel.addClass "panel-collapse"
          else
            $body.slideDown "normal", fit_main_content_height
            $panel.removeClass "panel-collapse"
          return
        # Data Toggle for Radio and Checkbox Elements
        $ "[data-toggle=\"buttons-radio\"]"
        .each ->
          $buttons = $ this
          .children()
          $buttons.each (i, el) ->
            $this = $ el
            $this.click (ev) ->
              $buttons.removeClass "active"
              return
            return
          return
        $ "[data-toggle=\"buttons-checkbox\"]"
        .each ->
          $buttons = $ this
          .children()
          $buttons.each (i, el) ->
            $this = $ el
            $this.click (ev) ->
              $this.removeClass "active"
              return
            return
          return
        $ "[data-loading-text]"
        .each (i, el) -> # Temporary for demo purpose only
          $this = $ el
          $this.on "click", (ev) ->
            $this.button "loading"
            setTimeout ->
              $this.button "reset"
              return
            , 1800
            return
          return
        # Popovers and tooltips
        $ "[data-toggle=\"popover\"]"
        .each (i, el) ->
          $this = $ el
          placement = attrDefault $this, "placement", "right"
          trigger = attrDefault $this, "trigger", "click"
          popover_class = if $this.hasClass("popover-secondary") then "popover-secondary" else ((if $this.hasClass("popover-primary") then "popover-primary" else ((if $this.hasClass("popover-default") then "popover-default" else ""))))
          $this.popover
            placement: placement
            trigger: trigger
          $this.on "shown.bs.popover", (ev) ->
            $popover = $this.next()
            $popover.addClass popover_class
            return
          return
        $ "[data-toggle=\"tooltip\"]"
        .each (i, el) ->
          $this = $ el
          placement = attrDefault $this, "placement", "top"
          trigger = attrDefault $this, "trigger", "hover"
          popover_class = if $this.hasClass("tooltip-secondary") then "tooltip-secondary" else ((if $this.hasClass("tooltip-primary") then "tooltip-primary" else ((if $this.hasClass("tooltip-default") then "tooltip-default" else ""))))
          $this.tooltip
            placement: placement
            trigger: trigger
          $this.on "shown.bs.tooltip", (ev) ->
            $tooltip = $this.next()
            $tooltip.addClass popover_class
            return
          return
        # jQuery Knob
        if $.isFunction $.fn.knob
          $ ".knob"
          .knob
              change: (value) ->
              release: (value) ->
              cancel: ->
              draw: ->
                if @$.data "skin" is "tron"
                  a = @angle @cv # Angle
                  sa = @startAngle # Previous start angle
                  sat = @startAngle # Start angle
                  ea = undefined
                  # Previous end angle
                  eat = sat + a # End angle
                  r = 1
                  @g.lineWidth = @lineWidth
                  @o.cursor and (sat = eat - 0.3) and (eat = eat + 0.3)
                  if @o.displayPrevious
                    ea = @startAngle + @angle(@v)
                    @o.cursor and (sa = ea - 0.3) and (ea = ea + 0.3)
                    @g.beginPath()
                    @g.strokeStyle = @pColor
                    @g.arc @xy, @xy, @radius - @lineWidth, sa, ea, false
                    @g.stroke()
                  @g.beginPath()
                  @g.strokeStyle = (if r then @o.fgColor else @fgColor)
                  @g.arc @xy, @xy, @radius - @lineWidth, sat, eat, false
                  @g.stroke()
                  @g.lineWidth = 2
                  @g.beginPath()
                  @g.strokeStyle = @o.fgColor
                  @g.arc @xy, @xy, @radius - @lineWidth + 1 + @lineWidth * 2 / 3, 0, 2 * Math.PI, false
                  @g.stroke()
                  false
        # Slider
        if $.isFunction $.fn.slider
          $ ".slider"
          .each (i, el) ->
            $this = $ el
            $label_1 = $ "<span class=\"ui-label\"></span>"
            $label_2 = $label_1.clone()
            orientation = if attrDefault($this, "vertical", 0) isnt 0 then "vertical" else "horizontal"
            prefix = attrDefault $this, "prefix", ""
            postfix = attrDefault $this, "postfix", ""
            fill = attrDefault $this, "fill", ""
            $fill = $ fill
            step = attrDefault $this, "step", 1
            value = attrDefault $this, "value", 5
            min = attrDefault $this, "min", 0
            max = attrDefault $this, "max", 100
            min_val = attrDefault $this, "min-val", 10
            max_val = attrDefault $this, "max-val", 90
            is_range = $this.is("[data-min-val]") or $this.is("[data-max-val]")
            reps = 0
            # Range Slider Options
            if is_range
              $this.slider
                range: true
                orientation: orientation
                min: min
                max: max
                values: [
                  min_val
                  max_val
                ]
                step: step
                slide: (e, ui) ->
                  opts = $this.data "uiSlider"
                  .options
                  min_val = (if prefix then prefix else "") + ui.values[0] + (if postfix then postfix else "")
                  max_val = (if prefix then prefix else "") + ui.values[1] + (if postfix then postfix else "")
                  $label_1.html min_val
                  $label_2.html max_val
                  $fill.val min_val + "," + max_val  if fill
                  reps++
                  return
                change: (ev, ui) ->
                  if reps is 1
                    opts = $this.data "uiSlider"
                    .options
                    min_val = (if prefix then prefix else "") + ui.values[0] + (if postfix then postfix else "")
                    max_val = (if prefix then prefix else "") + ui.values[1] + (if postfix then postfix else "")
                    $label_1.html min_val
                    $label_2.html max_val
                    $fill.val min_val + "," + max_val  if fill
                  reps = 0
                  return
              $handles = $this.find ".ui-slider-handle"
              $label_1.html (if prefix then prefix else "") + min_val + (if postfix then postfix else "")
              $handles.first().append $label_1
              $label_2.html (if prefix then prefix else "") + max_val + (if postfix then postfix else "")
              $handles.last().append $label_2
              # Normal Slider
            else
              $this.slider
                range: if attrDefault($this, "basic", 0) then false else "min"
                orientation: orientation
                min: min
                max: max
                value: value
                step: step
                slide: (ev, ui) ->
                  opts = $this.data "uiSlider"
                  .options
                  val = (if prefix then prefix else "") + opts.value + (if postfix then postfix else "")
                  $label_1.html val
                  $fill.val val  if fill
                  reps++
                  return
                change: (ev, ui) ->
                  if reps is 1
                    opts = $this.data "uiSlider"
                    .options
                    val = (if prefix then prefix else "") + opts.value + (if postfix then postfix else "")
                    $label_1.html val
                    $fill.val val  if fill
                  reps = 0
                  return
              $handles = $this.find ".ui-slider-handle"
              #$fill = $('<div class="ui-fill"></div>');
              $label_1.html (if prefix then prefix else "") + value + (if postfix then postfix else "")
              $handles.html $label_1
            return
        #$handles.parent().prepend( $fill );
        #$fill.width($handles.get(0).style.left);
        # Radio Toggle
        if $.isFunction $.fn.bootstrapSwitch
          $ ".make-switch.is-radio"
          .on "switch-change", ->
            $ ".make-switch.is-radio"
            .bootstrapSwitch "toggleRadioState"
            return
        # Select2 Dropdown replacement
        if $.isFunction $.fn.select2
          $ ".select2"
          .each (i, el) ->
            $this = $ el
            opts = allowClear: attrDefault $this, "allowClear", false
            $this.select2 opts
            $this.addClass "visible"
            return
          #$this.select2("open");
          if $.isFunction $.fn.niceScroll
            $ ".select2-results"
            .niceScroll
                cursorcolor: "#d4d4d4"
                cursorborder: "1px solid #ccc"
                railpadding:
                  right: 3
        # SelectBoxIt Dropdown replacement
        if $.isFunction $.fn.selectBoxIt
          $ "select.selectboxit"
          .each (i, el) ->
            $this = $ el
            opts =
              showFirstOption: attrDefault $this, "first-option", true
              native: attrDefault $this, "native", false
              defaultText: attrDefault $this, "text", ""
            $this.addClass "visible"
            $this.selectBoxIt opts
            return
        # Auto Size for Textarea
        $ "textarea.autogrow, textarea.autosize"
        .autosize()  if $.isFunction $.fn.autosize
        # Tagsinput
        $ ".tagsinput"
        .tagsinput()  if $.isFunction $.fn.tagsinput
        # Typeahead
        if $.isFunction $.fn.typeahead
          $ ".typeahead"
          .each (i, el) ->
            $this = $ el
            opts = name: if $this.attr("name") then $this.attr("name") else ((if $this.attr("id") then $this.attr("id") else "tt"))
            return  if $this.hasClass "tagsinput"
            if $this.data "local"
              local = $this.data "local"
              local = local.replace /\s*,\s*/g, ","
              .split ","
              opts["local"] = local
            if $this.data "prefetch"
              prefetch = $this.data "prefetch"
              opts["prefetch"] = prefetch
            if $this.data "remote"
              remote = $this.data "remote"
              opts["remote"] = remote
            if $this.data "template"
              template = $this.data "template"
              opts["template"] = template
              opts["engine"] = Hogan
            $this.typeahead opts
            return
        # Datepicker
        if $.isFunction $.fn.datepicker
          $ ".datepicker"
          .each (i, el) ->
            $this = $ el
            opts =
              format: attrDefault $this, "format", "mm/dd/yyyy"
              startDate: attrDefault $this, "startDate", ""
              endDate: attrDefault $this, "endDate", ""
              daysOfWeekDisabled: attrDefault $this, "disabledDays", ""
              startView: attrDefault($this, "startView", 0)
              rtl: rtl()
            $n = $this.next()
            $p = $this.prev()
            $this.datepicker opts
            if $n.is(".input-group-addon") and $n.has("a")
              $n.on "click", (ev) ->
                ev.preventDefault()
                $this.datepicker "show"
                return
            if $p.is(".input-group-addon") and $p.has("a")
              $p.on "click", (ev) ->
                ev.preventDefault()
                $this.datepicker "show"
                return
            return
        # Timepicker
        if $.isFunction($.fn.timepicker)
          $(".timepicker").each (i, el) ->
            $this = $(el)
            opts =
              template: attrDefault $this, "template", false
              showSeconds: attrDefault $this, "showSeconds", false
              defaultTime: attrDefault $this, "defaultTime", "current"
              showMeridian: attrDefault $this, "showMeridian", true
              minuteStep: attrDefault $this, "minuteStep", 15
              secondStep: attrDefault $this, "secondStep", 15
            $n = $this.next()
            $p = $this.prev()
            $this.timepicker opts
            if $n.is(".input-group-addon") and $n.has("a")
              $n.on "click", (ev) ->
                ev.preventDefault()
                $this.timepicker "showWidget"
                return
            if $p.is(".input-group-addon") and $p.has("a")
              $p.on "click", (ev) ->
                ev.preventDefault()
                $this.timepicker "showWidget"
                return
            return
        # Colorpicker
        if $.isFunction $.fn.colorpicker
          $ ".colorpicker"
          .each (i, el) ->
            $this = $ el
            opts = {}
            #format: attrDefault($this, 'format', false)
            $n = $this.next()
            $p = $this.prev()
            $preview = $this.siblings ".input-group-addon"
            .find ".color-preview"
            $this.colorpicker opts
            if $n.is(".input-group-addon") and $n.has("a")
              $n.on "click", (ev) ->
                ev.preventDefault()
                $this.colorpicker "show"
                return
            if $p.is(".input-group-addon") and $p.has("a")
              $p.on "click", (ev) ->
                ev.preventDefault()
                $this.colorpicker "show"
                return
            if $preview.length
              $this.on "changeColor", (ev) ->
                $preview.css "background-color", ev.color.toHex()
                return
              $preview.css "background-color", $this.val()  if $this.val().length
            return
        # Date Range Picker
        if $.isFunction $.fn.daterangepicker
          $ ".daterange"
          .each (i, el) ->
            # Change the range as you desire
            ranges =
              Today: [
                moment()
                moment()
              ]
              Yesterday: [
                moment().subtract "days", 1
                moment().subtract "days", 1
              ]
              "Last 7 Days": [
                moment().subtract "days", 6
                moment()
              ]
              "Last 30 Days": [
                moment().subtract "days", 29
                moment()
              ]
              "This Month": [
                moment().startOf "month"
                moment().endOf "month"
              ]
              "Last Month": [
                moment().subtract "month", 1
                .startOf "month"
                moment().subtract "month", 1
                .endOf "month"
              ]
            $this = $ el
            opts =
              format: attrDefault($this, "format", "MM/DD/YYYY")
              timePicker: attrDefault($this, "timePicker", false)
              timePickerIncrement: attrDefault($this, "timePickerIncrement", false)
              separator: attrDefault($this, "separator", " - ")
            min_date = attrDefault($this, "minDate", "")
            max_date = attrDefault($this, "maxDate", "")
            start_date = attrDefault($this, "startDate", "")
            end_date = attrDefault($this, "endDate", "")
            opts["ranges"] = ranges  if $this.hasClass("add-ranges")
            opts["minDate"] = min_date  if min_date.length
            opts["maxDate"] = max_date  if max_date.length
            opts["startDate"] = start_date  if start_date.length
            opts["endDate"] = end_date  if end_date.length
            $this.daterangepicker opts, (start, end) ->
              drp = $this.data("daterangepicker")
              #daterange_callback(start, end);
              callback_test start, end  if $this.is("[data-callback]")
              $this.find("span").html start.format(drp.format) + drp.separator + end.format(drp.format) if $this.hasClass("daterange-inline")
              return
            return
        # Input Mask
        if $.isFunction($.fn.inputmask)
          $("[data-mask]").each (i, el) ->
            $this = $(el)
            mask = $this.data("mask").toString()
            opts =
              numericInput: attrDefault($this, "numeric", false)
              radixPoint: attrDefault($this, "radixPoint", "")
              rightAlignNumerics: attrDefault($this, "numericAlign", "left") is "right"
            placeholder = attrDefault($this, "placeholder", "")
            is_regex = attrDefault($this, "isRegex", "")
            opts[placeholder] = placeholder  if placeholder.length
            switch mask.toLowerCase()
              when "phone"
                mask = "(999) 999-9999"
              when "currency", "rcurrency"
                sign = attrDefault($this, "sign", "$")
                mask = "999,999,999.99"
                if $this.data("mask").toLowerCase() is "rcurrency"
                  mask += " " + sign
                else
                  mask = sign + " " + mask
                opts.numericInput = true
                opts.rightAlignNumerics = false
                opts.radixPoint = "."
              when "email"
                mask = "Regex"
                opts.regex = "[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,4}"
              when "fdecimal"
                mask = "decimal"
                $.extend opts,
                  autoGroup: true
                  groupSize: 3
                  radixPoint: attrDefault($this, "rad", ".")
                  groupSeparator: attrDefault($this, "dec", ",")
            if is_regex
              opts.regex = mask
              mask = "Regex"
            $this.inputmask mask, opts
            return
        # Form Validation
        if $.isFunction($.fn.validate)
          $("form.validate").each (i, el) ->
            $this = $(el)
            opts =
              rules: {}
              messages: {}
              errorElement: "span"
              errorClass: "validate-has-error"
              highlight: (element) ->
                $(element).closest(".form-group").addClass "validate-has-error"
                return
              unhighlight: (element) ->
                $(element).closest(".form-group").removeClass "validate-has-error"
                return
              errorPlacement: (error, element) ->
                if element.closest(".has-switch").length
                  error.insertAfter element.closest(".has-switch")
                else if element.parent(".checkbox, .radio").length or element.parent(".input-group").length
                  error.insertAfter element.parent()
                else
                  error.insertAfter element
                return
            $fields = $this.find("[data-validate]")
            $fields.each (j, el2) ->
              $field = $(el2)
              name = $field.attr("name")
              validate = attrDefault($field, "validate", "").toString()
              _validate = validate.split(",")
              for k of _validate
                rule = _validate[k]
                params = undefined
                message = undefined
                if typeof opts["rules"][name] is "undefined"
                  opts["rules"][name] = {}
                  opts["messages"][name] = {}
                unless $.inArray(rule, [
                  "required"
                  "url"
                  "email"
                  "number"
                  "date"
                  "creditcard"
                ]) is -1
                  opts["rules"][name][rule] = true
                  message = $field.data("message-" + rule)
                  opts["messages"][name][rule] = message  if message
                  # Parameter Value (#1 parameter)
                else if params = rule.match /(\w+)\[(.*?)\]/i
                  unless $.inArray(params[1], [
                    "min"
                    "max"
                    "minlength"
                    "maxlength"
                    "equalTo"
                  ]) is -1
                    opts["rules"][name][params[1]] = params[2]
                    message = $field.data("message-" + params[1])
                    opts["messages"][name][params[1]] = message  if message
              return
            console.log opts
            $this.validate opts
            return
        # Replaced File Input
        $("input.file2[type=file]").each (i, el) ->
          $this = $(el)
          label = attrDefault($this, "label", "Browse")
          $this.bootstrapFileInput label
          return
        # Jasny Bootstrap | Fileinput
        $(".fileinput").fileinput()  if $.isFunction($.fn.fileinput)
        # Multi-select
        $(".multi-select").multiSelect()  if $.isFunction($.fn.multiSelect)
        # Form Wizard
        if $.isFunction($.fn.bootstrapWizard)
          $(".form-wizard").each (i, el) ->
            $this = $(el)
            $progress = $this.find(".steps-progress div")
            _index = $this.find("> ul > li.active").index()
            # Validation
            checkFormWizardValidaion = (tab, navigation, index) ->
              if $this.hasClass("validate")
                $valid = $this.valid()
                unless $valid
                  $this.data("validator").focusInvalid()
                  return false
              true
            $this.bootstrapWizard
              tabClass: ""
              onTabShow: ($tab, $navigation, index) ->
                setCurrentProgressTab $this, $navigation, $tab, $progress, index
                return
              onNext: checkFormWizardValidaion
              onTabClick: checkFormWizardValidaion
            $this.data("bootstrapWizard").show _index
            return
        #$(window).on('neon.resize', function()
        #		  	{
        #		  		$this.data('bootstrapWizard').show( _index );
        #		  	});
        # Wysiwyg Editor
        if $.isFunction($.fn.wysihtml5)
          $(".wysihtml5").each (i, el) ->
            $this = $(el)
            stylesheets = attrDefault($this, "stylesheet-url", "")
            $(".wysihtml5").wysihtml5 stylesheets: stylesheets.split(",")
            return
        # CKeditor WYSIWYG
        $(".ckeditor").ckeditor contentsLangDirection: (if rtl() then "rtl" else "ltr")  if $.isFunction($.fn.ckeditor)
        # Checkbox/Radio Replacement
        replaceCheckboxes()
        # Tile Progress
        $(".tile-progress").each (i, el) ->
          $this = $(el)
          $pct_counter = $this.find(".pct-counter")
          $progressbar = $this.find(".tile-progressbar span")
          percentage = parseFloat($progressbar.data("fill"))
          pct_len = percentage.toString().length
          if typeof scrollMonitor is "undefined"
            $progressbar.width percentage + "%"
            $pct_counter.html percentage
          else
            tile_progress = scrollMonitor.create(el)
            tile_progress.fullyEnterViewport ->
              $progressbar.width percentage + "%"
              tile_progress.destroy()
              o = pct: 0
              TweenLite.to o, 1,
                pct: percentage
                ease: Quint.easeInOut
                onUpdate: ->
                  pct_str = o.pct.toString().substring(0, pct_len)
                  $pct_counter.html pct_str
                  return
              return
          return
        # Tile Stats
        $(".tile-stats").each (i, el) ->
          $this = $(el)
          $num = $this.find(".num")
          start = attrDefault($num, "start", 0)
          end = attrDefault($num, "end", 0)
          prefix = attrDefault($num, "prefix", "")
          postfix = attrDefault($num, "postfix", "")
          duration = attrDefault($num, "duration", 1000)
          delay = attrDefault($num, "delay", 1000)
          if start < end
            if typeof scrollMonitor is "undefined"
              $num.html prefix + end + postfix
            else
              tile_stats = scrollMonitor.create(el)
              tile_stats.fullyEnterViewport ->
                o = curr: start
                TweenLite.to o, duration / 1000,
                  curr: end
                  ease: Power1.easeInOut
                  delay: delay / 1000
                  onUpdate: ->
                    $num.html prefix + Math.round(o.curr) + postfix
                    return
                tile_stats.destroy()
                return
          return
        # Tocify Table
        if $.isFunction($.fn.tocify) and $("#toc").length
          $("#toc").tocify
            context: ".tocify-content"
            selectors: "h2,h3,h4,h5"
          $this = $(".tocify")
          watcher = scrollMonitor.create($this.get(0))
          $this.width $this.parent().width()
          watcher.lock()
          watcher.stateChange ->
            $($this.get(0)).toggleClass "fixed", @isAboveViewport
            return
        # Modal Static
        public_vars.$body.on "click", ".modal[data-backdrop=\"static\"]", (ev) ->
          if $(ev.target).is(".modal")
            $modal_dialog = $(this).find(".modal-dialog .modal-content")
            tt = new TimelineMax(paused: true)
            tt.append TweenMax.to($modal_dialog, .1,
              css:
                scale: 1.1
              ease: Expo.easeInOut
            )
            tt.append TweenMax.to($modal_dialog, .3,
              css:
                scale: 1
              ease: Back.easeOut
            )
            tt.play()
          return
        # Added on v1.1
        # Sidebar User Links Popup
        if public_vars.$sidebarUserEnv.length
          $su_normal = public_vars.$sidebarUserEnv.find(".sui-normal")
          $su_hover = public_vars.$sidebarUserEnv.find(".sui-hover")
          if $su_normal.length and $su_hover.length
            public_vars.$sidebarUser.on "click", (ev) ->
              ev.preventDefault()
              $su_hover.addClass "visible"
              return
            $su_hover.on "click", ".close-sui-popup", (ev) ->
              ev.preventDefault()
              $su_hover.addClass "going-invisible"
              $su_hover.removeClass "visible"
              setTimeout (->
                $su_hover.removeClass "going-invisible"
                return
              ), 220
              return
        # End of: Added on v1.1
        # Added on v1.1.4
        $(".input-spinner").each (i, el) ->
          $this = $(el)
          $minus = $this.find("button:first")
          $plus = $this.find("button:last")
          $input = $this.find("input")
          minus_step = attrDefault($minus, "step", -1)
          plus_step = attrDefault($minus, "step", 1)
          min = attrDefault($input, "min", null)
          max = attrDefault($input, "max", null)
          $this.find("button").on "click", (ev) ->
            ev.preventDefault()
            $this = $(this)
            val = $input.val()
            step = attrDefault($this, "step", (if $this[0] is $minus[0] then -1 else 1))
            step = (if $this[0] is $minus[0] then -1 else 1)  unless step.toString().match(/^[0-9-\.]+$/)
            val = 0  unless val.toString().match(/^[0-9-\.]+$/)
            $input.val(parseFloat(val) + step).trigger "keyup"
            return
          $input.keyup ->
            if min? and parseFloat($input.val()) < min
              $input.val min
            else $input.val max  if max? and parseFloat($input.val()) > max
            return
          return
        # Search Results Tabs
        $search_results_env = $(".search-results-env")
        if $search_results_env.length
          $sr_nav_tabs = $search_results_env.find(".nav-tabs li")
          $sr_tab_panes = $search_results_env.find(".search-results-panes .search-results-pane")
          $sr_nav_tabs.find("a").on "click", (ev) ->
            ev.preventDefault()
            $this = $(this)
            $tab_pane = $sr_tab_panes.filter($this.attr("href"))
            $sr_nav_tabs.not($this.parent()).removeClass "active"
            $this.parent().addClass "active"
            $sr_tab_panes.not($tab_pane).fadeOut "fast", ->
              $tab_pane.fadeIn "fast"
              return
            return
        # End of: Added on v1.1.4
        # Fit main content height
        fit_main_content_height()
        fmch = 0
        fmch_fn = ->
          window.clearTimeout fmch
          fit_main_content_height()
          fmch = setTimeout(fmch_fn, 800)
          return
        fmch_fn()
        # Apply Page Transition
        onPageAppear init_page_transitions
        return
      # Enable/Disable Resizable Event
      wid = 0
      window
      .resize ->
        clearTimeout wid
        wid = setTimeout(trigger_resizable, 200)
        return
      # Functions
      fit_main_content_height = ->
        $ = jQuery
        if public_vars.$sidebarMenu.length and public_vars.$sidebarMenu.hasClass("fixed") is false
          public_vars.$sidebarMenu.css "min-height", ""
          public_vars.$mainContent.css "min-height", ""
          if isxs()
            reset_mail_container_height()  unless typeof reset_mail_container_height is "undefined"
            return
            reset_calendar_container_height()  unless typeof fit_calendar_container_height is "undefined"
            return
          sm_height = public_vars.$sidebarMenu.outerHeight()
          mc_height = public_vars.$mainContent.outerHeight()
          doc_height = $(document).height()
          win_height = $(window).height()
          sm_height_real = 0
          doc_height = win_height  if win_height > doc_height
          if public_vars.$horizontalMenu.length > 0
            hm_height = public_vars.$horizontalMenu.outerHeight()
            doc_height -= hm_height
            sm_height -= hm_height
          public_vars.$mainContent.css "min-height", doc_height
          public_vars.$sidebarMenu.css "min-height", doc_height
          public_vars.$chat.css "min-height", doc_height
          fit_mail_container_height()  unless typeof fit_mail_container_height is "undefined"
          fit_calendar_container_height()  unless typeof fit_calendar_container_height is "undefined"
        return
      # Sidebar Menu Setup
      setup_sidebar_menu = ->
        $ = jQuery
        $items_with_submenu = public_vars.$sidebarMenu.find("li:has(ul)")
        submenu_options =
          submenu_open_delay: 0.5
          submenu_open_easing: Sine.easeInOut
          submenu_opened_class: "opened"
        root_level_class = "root-level"
        is_multiopen = public_vars.$mainMenu.hasClass("multiple-expanded")
        public_vars.$mainMenu.find("> li").addClass root_level_class
        $items_with_submenu.each (i, el) ->
          $this = $(el)
          $link = $this.find("> a")
          $submenu = $this.find("> ul")
          $this.addClass "has-sub"
          $link.click (ev) ->
            ev.preventDefault()
            if not is_multiopen and $this.hasClass(root_level_class)
              close_submenus = public_vars.$mainMenu.find("." + root_level_class).not($this).find("> ul")
              close_submenus.each (i, el) ->
                $sub = $(el)
                menu_do_collapse $sub, $sub.parent(), submenu_options
                return
            unless $this.hasClass(submenu_options.submenu_opened_class)
              current_height = undefined
              menu_do_expand $submenu, $this, submenu_options  unless $submenu.is(":visible")
            else
              menu_do_collapse $submenu, $this, submenu_options
            fit_main_content_height()
            return
          return
        # Open the submenus with "opened" class
        public_vars.$mainMenu.find("." + submenu_options.submenu_opened_class + " > ul").addClass "visible"
        # Well, somebody may forgot to add "active" for all inhertiance, but we are going to help you (just in case) - we do this job for you for free :P!
        menu_set_active_class_to_parents public_vars.$mainMenu.find(".active")  if public_vars.$mainMenu.hasClass("auto-inherit-active-class")
        # Search Input
        $search_input = public_vars.$mainMenu.find("#search input[type=\"text\"]")
        $search_el = public_vars.$mainMenu.find("#search")
        public_vars.$mainMenu.find("#search form").submit (ev) ->
          is_collapsed = public_vars.$pageContainer.hasClass("sidebar-collapsed")
          if is_collapsed
            if $search_el.hasClass("focused") is false
              ev.preventDefault()
              $search_el.addClass "focused"
              $search_input.focus()
              false
        $search_input.on "blur", (ev) ->
          is_collapsed = public_vars.$pageContainer.hasClass("sidebar-collapsed")
          $search_el.removeClass "focused"  if is_collapsed
          return
        # Collapse Icon (mobile device visible)
        show_hide_menu = $("")
        public_vars.$sidebarMenu.find(".logo-env").append show_hide_menu
        return
      menu_do_expand = ($submenu, $this, options) ->
        $submenu.addClass("visible").height ""
        current_height = $submenu.outerHeight()
        props_from =
          opacity: .2
          height: 0
          top: -20
        props_to =
          height: current_height
          opacity: 1
          top: 0
        if isxs()
          delete props_from["opacity"]
          delete props_from["top"]
          delete props_to["opacity"]
          delete props_to["top"]
        TweenMax.set $submenu,
          css: props_from
        $this.addClass options.submenu_opened_class
        TweenMax.to $submenu, options.submenu_open_delay,
          css: props_to
          ease: options.submenu_open_easing
          onComplete: ->
            $submenu.attr "style", ""
            fit_main_content_height()
            return
        return
      menu_do_collapse = ($submenu, $this, options) ->
        return  if public_vars.$pageContainer.hasClass("sidebar-collapsed") and $this.hasClass("root-level")
        $this.removeClass options.submenu_opened_class
        TweenMax.to $submenu, options.submenu_open_delay,
          css:
            height: 0
            opacity: .2
          ease: options.submenu_open_easing
          onComplete: ->
            $submenu.removeClass "visible"
            fit_main_content_height()
            return
        return
      menu_set_active_class_to_parents = ($active_element) ->
        if $active_element.length
          $parent = $active_element.parent().parent()
          $parent.addClass "active"
          menu_set_active_class_to_parents $parent  unless $parent.hasClass("root-level")
        return
      # Horizontal Menu Setup
      setup_horizontal_menu = ->
        $ = jQuery
        $nav_bar_menu = public_vars.$horizontalMenu.find(".navbar-nav")
        $items_with_submenu = $nav_bar_menu.find("li:has(ul)")
        $search = public_vars.$horizontalMenu.find("li#search")
        $search_input = $search.find(".search-input")
        $search_submit = $search.find("form")
        root_level_class = "root-level"
        is_multiopen = $nav_bar_menu.hasClass("multiple-expanded")
        submenu_options =
          submenu_open_delay: 0.5
          submenu_open_easing: Sine.easeInOut
          submenu_opened_class: "opened"
        $nav_bar_menu.find("> li").addClass root_level_class
        $items_with_submenu.each (i, el) ->
          $this = $(el)
          $link = $this.find("> a")
          $submenu = $this.find("> ul")
          $this.addClass "has-sub"
          setup_horizontal_menu_hover $this, $submenu
          # xs devices only
          $link.click (ev) ->
            if isxs()
              ev.preventDefault()
              if not is_multiopen and $this.hasClass(root_level_class)
                close_submenus = $nav_bar_menu.find("." + root_level_class).not($this).find("> ul")
                close_submenus.each (i, el) ->
                  $sub = $(el)
                  menu_do_collapse $sub, $sub.parent(), submenu_options
                  return
              unless $this.hasClass(submenu_options.submenu_opened_class)
                current_height = undefined
                menu_do_expand $submenu, $this, submenu_options  unless $submenu.is(":visible")
              else
                menu_do_collapse $submenu, $this, submenu_options
              fit_main_content_height()
            return
          return
        # Search Input
        if $search.hasClass("search-input-collapsed")
          $search_submit.submit (ev) ->
            if $search.hasClass("search-input-collapsed")
              ev.preventDefault()
              $search.removeClass "search-input-collapsed"
              $search_input.focus()
              false
          $search_input.on "blur", (ev) ->
            $search.addClass "search-input-collapsed"
            return
        return
      jQuery public_vars,
        hover_index: 4
      setup_horizontal_menu_hover = ($item, $sub) ->
        del = 0.5
        trans_x = -10
        ease = Quad.easeInOut
        TweenMax.set $sub,
          css:
            autoAlpha: 0
            transform: "translateX(" + trans_x + "px)"
        $item.hoverIntent
          over: ->
            return false  if isxs()
            if $sub.css("display") is "none"
              $sub.css
                display: "block"
                visibility: "hidden"
            $sub.css zIndex: ++public_vars.hover_index
            TweenMax.to $sub, del,
              css:
                autoAlpha: 1
                transform: "translateX(0px)"
              ease: ease
            return
          out: ->
            return false  if isxs()
            TweenMax.to $sub, del,
              css:
                autoAlpha: 0
                transform: "translateX(" + trans_x + "px)"
              ease: ease
              onComplete: ->
                TweenMax.set $sub,
                  css:
                    transform: "translateX(" + trans_x + "px)"
                $sub.css display: "none"
                return
            return
          timeout: 300
          interval: 50
        return
      # Block UI Helper
      blockUI = ($el) ->
        $el.block
          message: ""
          css:
            border: "none"
            padding: "0px"
            backgroundColor: "none"
          overlayCSS:
            backgroundColor: "#fff"
            opacity: .3
            cursor: "wait"
        return
      unblockUI = ($el) ->
        $el.unblock()
        return
      # Element Attribute Helper
      attrDefault = ($el, data_var, default_val) ->
        return $el.data(data_var)  unless typeof $el.data(data_var) is "undefined"
        default_val
      # Test function
      callback_test = ->
        alert "Callback function executed! No. of arguments: " + arguments.length + "\n\nSee console log for outputed of the arguments."
        console.log arguments
        return
      # Root Wizard Current Tab
      setCurrentProgressTab = ($rootwizard, $nav, $tab, $progress, index) ->
        $tab.prevAll().addClass "completed"
        $tab.nextAll().removeClass "completed"
        items = $nav.children().length
        pct = parseInt((index + 1) / items * 100, 10)
        $first_tab = $nav.find("li:first-child")
        margin = (1 / (items * 2) * 100) + "%" #$first_tab.find('span').position().left + 'px';
        if $first_tab.hasClass("active")
          $progress.width 0
        else
          if rtl()
            $progress.width $progress.parent().outerWidth(true) - $tab.prev().position().left - $tab.find("span").width() / 2
          else
            $progress.width ((index - 1) / (items - 1)) * 100 + "%" #$progress.width( $tab.prev().position().left - $tab.find('span').width()/2 );
        $progress.parent().css
          marginLeft: margin
          marginRight: margin
        return
      #var m = $first_tab.find('span').position().left - $first_tab.find('span').width() / 2;
      #
      #	$rootwizard.find('.tab-content').css({
      #		marginLeft: m,
      #		marginRight: m
      #	});
      # Replace Checkboxes
      replaceCheckboxes = ->
        $ = jQuery
        $(".checkbox-replace:not(.neon-cb-replacement), .radio-replace:not(.neon-cb-replacement)").each (i, el) ->
          $this = $(el)
          $input = $this.find("input:first")
          $wrapper = $("<label class=\"cb-wrapper\" />")
          $checked = $("<div class=\"checked\" />")
          checked_class = "checked"
          is_radio = $input.is("[type=\"radio\"]")
          $related = undefined
          name = $input.attr("name")
          $this.addClass "neon-cb-replacement"
          $input.wrap $wrapper
          $wrapper = $input.parent()
          $wrapper.append($checked).next("label").on "click", (ev) ->
            $wrapper.click()
            return
          #$(".neon-cb-replacement input[type=radio][name='"+name+"']").closest('.neon-cb-replacement').removeClass(checked_class);
          $input.on("change", (ev) ->
            $(".neon-cb-replacement input[type=radio][name='" + name + "']:not(:checked)").closest(".neon-cb-replacement").removeClass checked_class  if is_radio
            $wrapper.addClass "disabled"  if $input.is(":disabled")
            $this[(if $input.is(":checked") then "addClass" else "removeClass")] checked_class
            return
          ).trigger "change"
          return
        return
      # Scroll to Bottom
      scrollToBottom = ($el) ->
        $ = jQuery
        $el = $($el)  if typeof $el is "string"
        $el.get(0).scrollTop = $el.get(0).scrollHeight
        return
      # Check viewport visibility (entrie element)
      elementInViewport = (el) ->
        top = el.offsetTop
        left = el.offsetLeft
        width = el.offsetWidth
        height = el.offsetHeight
        while el.offsetParent
          el = el.offsetParent
          top += el.offsetTop
          left += el.offsetLeft
        top >= window.pageYOffset and left >= window.pageXOffset and (top + height) <= (window.pageYOffset + window.innerHeight) and (left + width) <= (window.pageXOffset + window.innerWidth)
      # X Overflow
      disableXOverflow = ->
        public_vars.$body.addClass "overflow-x-disabled"
        return
      enableXOverflow = ->
        public_vars.$body.removeClass "overflow-x-disabled"
        return
      # Page Transitions
      init_page_transitions = ->
        fit_main_content_height()
        transitions = [
          "page-fade"
          "page-left-in"
          "page-right-in"
          "page-fade-only"
        ]
        for i of transitions
          transition_name = transitions[i]
          if public_vars.$body.hasClass(transition_name)
            public_vars.$body.addClass transition_name + "-init"
            setTimeout (->
              public_vars.$body.removeClass transition_name + " " + transition_name + "-init"
              return
            ), 850
            return
        return
      # Page Visibility API
      onPageAppear = (callback) ->
        hidden = undefined
        state = undefined
        visibilityChange = undefined
        if typeof document.hidden isnt "undefined"
          hidden = "hidden"
          visibilityChange = "visibilitychange"
          state = "visibilityState"
        else if typeof document.mozHidden isnt "undefined"
          hidden = "mozHidden"
          visibilityChange = "mozvisibilitychange"
          state = "mozVisibilityState"
        else if typeof document.msHidden isnt "undefined"
          hidden = "msHidden"
          visibilityChange = "msvisibilitychange"
          state = "msVisibilityState"
        else if typeof document.webkitHidden isnt "undefined"
          hidden = "webkitHidden"
          visibilityChange = "webkitvisibilitychange"
          state = "webkitVisibilityState"
        callback()  if document[state] or typeof document[state] is "undefined"
        document.addEventListener visibilityChange, callback, false
        return
      continueWrappingPanelTables = ->
        $tables = jQuery(".panel-body.with-table + table")
        if $tables.length
          $tables.wrap "<div class=\"panel-body with-table\"></div>"
          continueWrappingPanelTables()
        return
      show_loading_bar = (options) ->
        defaults =
          pct: 0
          delay: 1.3
          wait: 0
          before: ->
          finish: ->
          resetOnEnd: true
        if typeof options is "object"
          defaults = jQuery.extend(defaults, options)
        else defaults.pct = options  if typeof options is "number"
        if defaults.pct > 100
          defaults.pct = 100
        else defaults.pct = 0  if defaults.pct < 0
        $ = jQuery
        $loading_bar = $(".neon-loading-bar")
        if $loading_bar.length is 0
          $loading_bar = $("<div class=\"neon-loading-bar progress-is-hidden\"><span data-pct=\"0\"></span></div>")
          public_vars.$body.append $loading_bar
        $pct = $loading_bar.find("span")
        current_pct = $pct.data("pct")
        is_regress = current_pct > defaults.pct
        defaults.before current_pct
        TweenMax.to $pct, defaults.delay,
          css:
            width: defaults.pct + "%"
          delay: defaults.wait
          ease: (if is_regress then Expo.easeOut else Expo.easeIn)
          onStart: ->
            $loading_bar.removeClass "progress-is-hidden"
            return
          onComplete: ->
            pct = $pct.data("pct")
            hide_loading_bar()  if pct is 100 and defaults.resetOnEnd
            defaults.finish pct
            return
          onUpdate: ->
            $pct.data "pct", parseInt($pct.get(0).style.width, 10)
            return
        return
      hide_loading_bar = ->
        $ = jQuery
        $loading_bar = $(".neon-loading-bar")
        $pct = $loading_bar.find("span")
        $loading_bar.addClass "progress-is-hidden"
        $pct.width(0).data "pct"
        return
      return