(function() {
  var template = Handlebars.template, templates = window.templates = window.templates || {};
templates['partials/game-controls'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<canvas class=\"game-controls\" width=\"";
  if (stack1 = helpers.width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" height=\"";
  if (stack1 = helpers.height) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.height; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"><canvas>";
  return buffer;
  });
templates['partials/game-decorator'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<span class=\"game-sprite game-decorator\"></span>";
  });
templates['partials/game-entity'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<span class=\"game-entity\"></span>";
  });
templates['partials/game-lasers'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<svg xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\" width=\"";
  if (stack1 = helpers.width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" height=\"";
  if (stack1 = helpers.height) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.height; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"></svg>";
  return buffer;
  });
templates['partials/game-layer'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"game-layer\"></div>";
  });
templates['partials/game-sprite'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<span class=\"game-sprite\"></span>";
  });
templates['partials/game-stage'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"game-stage\"></div>";
  });
templates['partials/game-walls'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<div class=\"game-walls\">\n	<svg xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\" width=\"";
  if (stack1 = helpers.width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" height=\"";
  if (stack1 = helpers.height) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.height; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"></svg>\n</div>";
  return buffer;
  });
templates['partials/modal-end-game'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this;

function program1(depth0,data) {
  
  
  return "\n\n	<a href=\"#\" class=\"button-back\" data-role=\"back\">\n		<i class=\"icon-chevron-left\"></i>\n	</a>\n\n";
  }

function program3(depth0,data) {
  
  
  return "\n\n	<div class=\"stars\">\n		<div class=\"star-holder\">\n			<i class=\"icon-star\"></i>\n			<i class=\"icon-star star\"></i>\n		</div>\n		<div class=\"star-holder\">\n			<i class=\"icon-star\"></i>\n			<i class=\"icon-star star\"></i>\n		</div>\n		<div class=\"star-holder\">\n			<i class=\"icon-star\"></i>\n			<i class=\"icon-star star\"></i>\n		</div>\n	</div>\n\n	<div class=\"actions\">\n		\n		<a href=\"#\" data-role=\"restart\">\n			<i class=\"icon-rotate-left\"></i>\n			Restart\n		</a>\n\n		<a href=\"#\" class=\"primary\" data-role=\"next\">\n			Next\n			<i class=\"icon-chevron-right\"></i>\n		</a>\n\n	</div>\n\n";
  }

function program5(depth0,data) {
  
  
  return "\n\n	<div class=\"actions\">\n		\n		<a href=\"#\" data-role=\"back\">\n			<i class=\"icon-list\"></i>\n			Levels\n		</a>\n\n		<a href=\"#\" class=\"primary\" data-role=\"restart\">\n			<i class=\"icon-rotate-left\"></i>\n			Try Again\n		</a>\n\n	</div>\n\n";
  }

  stack1 = helpers['if'].call(depth0, depth0.win, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n";
  stack1 = helpers['if'].call(depth0, depth0.win, {hash:{},inverse:self.program(5, program5, data),fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  return buffer;
  });
templates['partials/modal-pause'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"actions\">\n\n	<a href=\"#\" data-role=\"restart\">\n		<i class=\"icon-rotate-left\"></i>\n		Restart\n	</a>\n	\n	<a href=\"#\" class=\"primary\" data-role=\"resume\">\n		Resume\n		<i class=\"icon-chevron-right\"></i>\n	</a>\n\n</div>\n\n<a class=\"button-flat-light block\" data-role=\"back\">\n	<i class=\"icon-list\"></i>\n	Levels\n</a>";
  });
templates['partials/modal-tutorial'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function";


  buffer += "<div class=\"inner\">\n\n	<div class=\"text\">\n		";
  if (stack1 = helpers.text) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.text; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n	</div>\n\n	<a href=\"#\" class=\"button-flat-light block\" data-role=\"done\">\n		<i class=\"icon-ok\"></i>\n		Got it\n	</a>\n\n</div>";
  return buffer;
  });
templates['partials/modal'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n			<h1 class=\"modal-head\">\n\n				";
  stack1 = helpers['if'].call(depth0, depth0.icon, {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n				";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.title; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n			</h1>\n		";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n					<i class=\"icon-";
  if (stack1 = helpers.icon) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.icon; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\"></i>\n				";
  return buffer;
  }

  buffer += "<div class=\"modal-wrap\">\n	<div class=\"overlay\"></div>\n	<div class=\"modal ";
  if (stack1 = helpers['class-names']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0['class-names']; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">\n		";
  stack1 = helpers['if'].call(depth0, depth0.title, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n		<div class=\"modal-body\">";
  if (stack1 = helpers.body) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.body; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "</div>\n	</div>\n</div>";
  return buffer;
  });
templates['partials/svg-circle'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<circle style=\"fill: ";
  if (stack1 = helpers.fill) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.fill; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + ";\" cx=\"";
  if (stack1 = helpers['x']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0['x']; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" cy=\"";
  if (stack1 = helpers['y']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0['y']; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" r=\"";
  if (stack1 = helpers.radius) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.radius; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" />";
  return buffer;
  });
templates['partials/svg-poly'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<polygon style=\"fill: ";
  if (stack1 = helpers.fill) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.fill; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + ";\" points=\"";
  if (stack1 = helpers.points) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.points; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" />";
  return buffer;
  });
templates['partials/svg-rect'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<rect style=\"fill: ";
  if (stack1 = helpers.fill) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.fill; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + ";\" x=\"";
  if (stack1 = helpers['x']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0['x']; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" y=\"";
  if (stack1 = helpers['y']) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0['y']; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" width=\"";
  if (stack1 = helpers.width) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.width; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" height=\"";
  if (stack1 = helpers.height) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.height; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" />";
  return buffer;
  });
templates['views/game'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<span class=\"reset-button\" data-role=\"reset\">\n	<i class=\"icon-refresh\"></i>\n</span>\n\n<span class=\"shots-counter\">\n	<i class=\"icon-bullseye\"></i>\n	<span class=\"inner\" data-role=\"shots-counter\">-</span>\n</span>\n\n<span class=\"pause-button\" data-role=\"pause\">\n	<i class=\"icon-pause\"></i>\n</span>";
  });
templates['views/home'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  


  return "<div class=\"inner\">\n\n	<div class=\"main-nav\">\n\n		<img class=\"logo\" src=\"./assets/logo/home@2x.png\">\n\n		<a class=\"button-flat block\" data-role=\"nav-play\" href=\"#\">\n			<i class=\"icon-gamepad\"></i>\n			Play\n		</a>\n		<a class=\"button-flat block\" data-role=\"nav-levels\" href=\"#\">\n			<i class=\"icon-list\"></i>\n			Levels\n		</a>\n	</div>\n\n</div>";
  });
templates['views/levels'] = template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, self=this, functionType="function", escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n		<li class=\"";
  stack1 = helpers['if'].call(depth0, depth0.locked, {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\" data-role=\"level\" data-level-name=\"";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.name; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">\n			";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = depth0.name; stack1 = typeof stack1 === functionType ? stack1.apply(depth0) : stack1; }
  buffer += escapeExpression(stack1)
    + "\n			<div class=\"progress\">\n				";
  stack1 = helpers['if'].call(depth0, depth0.locked, {hash:{},inverse:self.program(6, program6, data),fn:self.program(4, program4, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n			</div>\n		</li>\n	";
  return buffer;
  }
function program2(depth0,data) {
  
  
  return "locked";
  }

function program4(depth0,data) {
  
  
  return "\n					<i class=\"icon-lock\"></i>\n				";
  }

function program6(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n					";
  stack1 = helpers.each.call(depth0, depth0.stars, {hash:{},inverse:self.noop,fn:self.program(7, program7, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n				";
  return buffer;
  }
function program7(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n						<i class=\"icon-star star ";
  stack1 = helpers['if'].call(depth0, depth0.scored, {hash:{},inverse:self.noop,fn:self.program(8, program8, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\"></i>\n					";
  return buffer;
  }
function program8(depth0,data) {
  
  
  return "scored";
  }

  buffer += "<div class=\"top-bar fixed\">\n	\n	<a class=\"top-bar-button button-left\" href=\"#\" data-role=\"nav-home\">\n		<i class=\"icon-caret-left\"></i>\n	</a>\n\n	<h1 class=\"center\">Levels</h1>\n\n</div>\n\n<ul class=\"levels-list\">\n	";
  stack1 = helpers.each.call(depth0, depth0.levels, {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>";
  return buffer;
  });
})();