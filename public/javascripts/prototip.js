//  Prototip 1.1.0
//  by Nick Stakenburg - http://www.nickstakenburg.com
//  08-11-2007
//
//  More information on this project:
//  http://www.nickstakenburg.com/projects/prototip/
//
//  Licensed under the Creative Commons Attribution 3.0 License
//  http://creativecommons.org/licenses/by/3.0/
//

var Prototip = {
  Version: '1.1.0',

  REQUIRED_Prototype: '1.6.0',
  REQUIRED_Scriptaculous: '1.8.0',

  start: function() { this.require('Prototype'); },

  require: function(library) {
    if ((typeof window[library] == 'undefined') ||
      (this.convertVersionString(window[library].Version) < this.convertVersionString(this['REQUIRED_' + library])))
      throw('Prototip requires ' + library + ' >= ' + this['REQUIRED_' + library]);
  },

  // based on Scriptaculous' implementation
  convertVersionString: function(versionString) {
    var r = versionString.split('.');
    return parseInt(r[0])*100000 + parseInt(r[1])*1000 + parseInt(r[2]);
  },

  // fixed viewport.getDimensions. Also excludes scrollbars in firefox. Valid doctype required.
  viewport : {
    getDimensions: function() {
      var dimensions = { };
      var B = Prototype.Browser;
      $w('width height').each(function(d) {
        var D = d.capitalize();
        if (B.Opera) dimensions[d] = document.body['client' + D];
        else if (B.WebKit) dimensions[d] = self['inner' + D];
        else dimensions[d] = document.documentElement['client' + D];
        });
      return dimensions;
    }
  }
};
Prototip.start();

var Tips = {
  // Configuration
  closeButtons: false,
  zIndex: 1200,

  fixIE: (function(agent){
    var version = new RegExp('MSIE ([\\d.]+)').exec(agent);
    return version ? (parseFloat(version[1]) <= 6) : false;
  })(navigator.userAgent),

  tips : [],
  visible : [],

  add: function(tip) {
    this.tips.push(tip);
  },

  remove: function(element) {
    var tip = this.tips.find(function(t){ return t.element == $(element); });
    if (tip) {
      tip.deactivate();
      if (tip.tooltip) {
        tip.wrapper.remove();
        if (Tips.fixIE) tip.iframeShim.remove();
      }
      this.tips = this.tips.without(tip);
    }
  },

  zIndexRestore : 1200,
  raise: function(tip) {
    var highestZ = this.zIndexHighest();
    if (!highestZ) {
      tip.style.zIndex = this.zIndexRestore;
      return;
    }
    var newZ = (tip.style.zIndex != highestZ) ? highestZ + 1 : highestZ;
    this.tips.pluck('wrapper').invoke('removeClassName', 'highest');
							
    tip.setStyle({ zIndex : newZ }).addClassName('highest');
  },

  zIndexHighest: function() {
    var highestZ = this.visible.max(function(v) {
      return parseInt(v.style.zIndex);
    });
    return highestZ;
  },

  addVisibile: function(tip) {
    this.removeVisible(tip);
    this.visible.push(tip);
  },

  removeVisible: function(tip) {
    this.visible = this.visible.without(tip);
  }
};

var Tip = Class.create({
  initialize: function(element, content) {
    this.element = $(element);
    Tips.remove(this.element);
	
    this.content = content;    

    var isHooking = (arguments[2] && arguments[2].hook);
    var isShowOnClick = (arguments[2] && arguments[2].showOn == 'click');

    this.options = Object.extend({
      className: 'default',                 // see css, this will lead to .prototip .default
      closeButton: Tips.closeButtons,       // true, false
      delay: !isShowOnClick ? 0.2 : false,  // seconds before tooltip appears
      duration: 0.3,                        // duration of the effect
      effect: false,                        // false, 'appear' or 'blind'
      hideOn: 'mouseout',
      hook: false,                          // { element: topLeft|topRight|bottomLeft|bottomRight, tip: see element }
      offset: isHooking ? {x:0, y:0} : {x:16, y:16},
      fixed: isHooking ? true : false,      // follow the mouse if false
      showOn: 'mousemove',
      target: this.element,                 // or another element
      title: false,

      viewport: isHooking ? false : true    // keep within viewport if mouse is followed
    }, arguments[2] || {});

    this.target = $(this.options.target);

    this.setup();

    if (this.options.effect) {
      Prototip.require('Scriptaculous');
      this.queue = { position: 'end', limit: 1, scope: this.wrapper.identify() }
    }

    Tips.add(this);
    this.activate();
  },

  setup: function() {
    // Everything that needs to be build for observing is done here
    this.wrapper = new Element('div', { 'class' : 'prototip' }).setStyle({
      display: 'none', zIndex: Tips.zIndex++ });
    this.wrapper.identify();	

    if (Tips.fixIE) {
      this.iframeShim = new Element('iframe', { 'class' : 'iframeShim', src: 'javascript:false;' }).setStyle({
        display: 'none', zIndex: Tips.zIndexRestore - 1 });
    }

    this.tip = new Element('div', { 'class' : 'content' }).update(this.content);
    this.tip.insert(new Element('div').setStyle({ clear: 'both' }));

    if (this.options.closeButton || (this.options.hideOn.element && this.options.hideOn.element == 'closeButton'))
      this.closeButton = new Element('a', { href: 'javascript:;', 'class' : 'close' });
  },

  build: function() {
    if (Tips.fixIE) document.body.appendChild(this.iframeShim).setOpacity(0);

    // effects go smooth with extra wrapper
    var wrapper = 'wrapper';
    if (this.options.effect) {
      this.effectWrapper = this.wrapper.appendChild(new Element('div', { 'class' : 'effectWrapper' }));
      wrapper = 'effectWrapper';
    }

    this.tooltip = this[wrapper].appendChild(new Element('div', { 'class' : 'tooltip ' + this.options.className }));

    if (this.options.title || this.options.closeButton) {
      this.toolbar = this.tooltip.appendChild(new Element('div', { 'class' : 'toolbar' }));
      this.title = this.toolbar.appendChild(new Element('div', { 'class' : 'title' }).update(this.options.title || ' '));
    }

    this.tooltip.insert(this.tip);
    document.body.appendChild(this.wrapper);
	
    // fixate elements for better positioning and effects
    var fixate = (this.options.effect) ? [this.wrapper, this.effectWrapper]: [this.wrapper];
    if (Tips.fixIE) fixate.push(this.iframeShim);

    // fix width
    var fixedWidth = this.wrapper.getWidth();
    fixate.invoke('setStyle', { width: fixedWidth + 'px' });
	
    // make toolbar width fixed
    if(this.toolbar) {
      this.wrapper.setStyle({ visibility : 'hidden' }).show();
      this.toolbar.setStyle({ width: this.toolbar.getWidth() + 'px'});
      this.wrapper.hide().setStyle({ visibility : 'visible' });
    }

    // add close button
    if (this.closeButton)
      this.title.insert({ top: this.closeButton }).insert(new Element('div').setStyle({ clear: 'both' }));

    var fixedHeight = this.wrapper.getHeight();
    fixate.invoke('setStyle', { width: fixedWidth + 'px', height: fixedHeight + 'px' });

    this[this.options.effect ? wrapper : 'tooltip'].hide();
  },

  activate: function() {
    this.eventShow = this.showDelayed.bindAsEventListener(this);
    this.eventHide = this.hide.bindAsEventListener(this);

    // if fixed use mouseover instead of mousemove for less event calls
    if (this.options.fixed && this.options.showOn == 'mousemove') this.options.showOn = 'mouseover';

    if(this.options.showOn == this.options.hideOn) {
      this.eventToggle = this.toggle.bindAsEventListener(this);
      this.element.observe(this.options.showOn, this.eventToggle);
    }

    this.hideElement = Object.isUndefined(this.options.hideOn.element) ? 'element' : this.options.hideOn.element;
    var hideOptions = {
      'element': this.eventToggle ? [] : [this.element],
      'target': this.eventToggle ? [] : [this.target],
      'tip': this.eventToggle ? [] : [this.wrapper],
      'closeButton': [],
      '.close' : this.tip.select('.close')
    }
    this.hideTargets = hideOptions[this.hideElement];

    // add show and hide observers
    if (this.element && !this.eventToggle) this.element.observe(this.options.showOn, this.eventShow);
    this.hideAction = (this.options.hideOn.event || this.options.hideOn);
    if (this.hideTargets) this.hideTargets.invoke('observe', this.hideAction, this.eventHide);

    // add position observer if not fixed
    if (!this.options.fixed && this.options.showOn == 'click') {
      this.eventPosition = this.position.bindAsEventListener(this);
      this.element.observe('mousemove', this.eventPosition);
    }

    // add hide observers to close button and non click elements when they are not the close (delay needs this)
    if (this.closeButton) this.closeButton.observe('click', this.eventHide);
    if (this.options.showOn != 'click' && this.hideElement != 'element') {
      this.eventCheckDelay = this.checkDelay.bindAsEventListener(this);
      this.element.observe('mouseout', this.eventCheckDelay);
    }

    // observe wrapper to raise zIndex
    this.wrapper.observe('mouseover', function(){ Tips.raise(this.wrapper); }.bind(this));
  },

  deactivate: function() {
    if(this.options.showOn == this.options.hideOn) 
      this.element.stopObserving(this.options.showOn, this.eventToggle);
    else {
      this.element.stopObserving(this.options.showOn, this.eventShow);
      this.hideTargets.invoke('stopObserving', this.hideAction, this.eventHide);
    }

    if (this.eventPosition) this.element.stopObserving('mousemove', this.eventPosition);
    if (this.closeButton) this.closeButton.stopObserving();
    if (this.eventCheckDelay) this.element.stopObserving('mouseout', this.eventCheckDelay);
    this.wrapper.stopObserving();
  },

  showDelayed: function(event){
    if (!this.tooltip) this.build();
    this.position(event); // follow mouse
    if (this.wrapper.visible()) return;

    this.checkDelay();
    this.timer = this.show.bind(this).delay(this.options.delay);
  },

  checkDelay: function(){
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
  },

  show: function(){
    if (this.wrapper.visible() && this.options.effect != 'appear') return;

    if (Tips.fixIE) this.iframeShim.show();
    Tips.addVisibile(this.wrapper);
    this.wrapper.show();

    if (!this.options.effect) this.tooltip.show();
    else {
      if (this.activeEffect) Effect.Queues.get(this.queue.scope).remove(this.activeEffect);
      this.activeEffect = Effect[Effect.PAIRS[this.options.effect][0]](this.effectWrapper,
        { duration: this.options.duration, queue: this.queue});
    }
  },

  hide: function(){
    this.checkDelay();
    if(!this.wrapper.visible()) return;

    if (!this.options.effect) {
      if (Tips.fixIE) this.iframeShim.hide();
      this.tooltip.hide();
      this.wrapper.hide();
      Tips.removeVisible(this.wrapper);
    }
    else {
      if (this.activeEffect) Effect.Queues.get(this.queue.scope).remove(this.activeEffect);
      this.activeEffect = Effect[Effect.PAIRS[this.options.effect][1]](this.effectWrapper, 
        { duration: this.options.duration, queue: this.queue, afterFinish: function(){
        if (Tips.fixIE) this.iframeShim.hide();
        this.wrapper.hide();
        Tips.removeVisible(this.wrapper);
      }.bind(this)});
    }
  },

  toggle: function(event){
    if (this.wrapper && this.wrapper.visible()) this.hide(event);
    else this.showDelayed(event);
  },

  position: function(event){
    if (!this.wrapper.hasClassName('highest')) Tips.raise(this.wrapper);

    var offset = {left: this.options.offset.x, top: this.options.offset.y};
    var targetPosition = Position.cumulativeOffset(this.target);
    var tipd = this.wrapper.getDimensions();
    var pos = { left: (this.options.fixed) ? targetPosition[0] : Event.pointerX(event),
      top: (this.options.fixed) ? targetPosition[1] : Event.pointerY(event) };

    // add offsets
    pos.left += offset.left;
    pos.top += offset.top;

    if (this.options.hook) {
      var dims = {target: this.target.getDimensions(), tip: tipd}
      var hooks = {target: Position.cumulativeOffset(this.target), tip: Position.cumulativeOffset(this.target)}

      for(var z in hooks) {
        switch(this.options.hook[z]){
          case 'topRight':
            hooks[z][0] += dims[z].width;
            break;
          case 'topMiddle':
            hooks[z][0] += (dims[z].width / 2);
            break;
          case 'rightMiddle':
            hooks[z][0] += dims[z].width;
            hooks[z][1] += (dims[z].height / 2);
            break;
          case 'bottomLeft':
            hooks[z][1] += dims[z].height;
            break;
          case 'bottomRight':
            hooks[z][0] += dims[z].width;
            hooks[z][1] += dims[z].height;
            break;
          case 'bottomMiddle':
            hooks[z][0] += (dims[z].width / 2);
            hooks[z][1] += dims[z].height;
            break;
          case 'leftMiddle':
            hooks[z][1] += (dims[z].height / 2);
            break;
        }
      }

      // move based on hooks
      pos.left += -1*(hooks.tip[0] - hooks.target[0]);
      pos.top += -1*(hooks.tip[1] - hooks.target[1]);
    }

    // move tooltip when there is a different target
    if (!this.options.fixed && this.element !== this.target) {
      var elementPosition = Position.cumulativeOffset(this.element);
      pos.left += -1*(elementPosition[0] - targetPosition[0]);
      pos.top += -1*(elementPosition[1] - targetPosition[1]);
    }

    if (!this.options.fixed && this.options.viewport) {
      var scroll = document.viewport.getScrollOffsets();
      var viewport = Prototip.viewport.getDimensions();
      var pair = {left: 'width', top: 'height'};

      for(var z in pair) {
        if ((pos[z] + tipd[pair[z]] - scroll[z]) > viewport[pair[z]])
          pos[z] = pos[z] - tipd[pair[z]] - 2*offset[z];
      }
    }

    var finalPosition = { left: pos.left + 'px', top: pos.top + 'px' };
    this.wrapper.setStyle(finalPosition);
    if (Tips.fixIE) this.iframeShim.setStyle(finalPosition);
  }
});