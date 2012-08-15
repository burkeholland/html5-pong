(function() {
  var Ball, GAME_HEIGHT, GAME_WIDTH, GUTTER, Paddle, Sound, Sprite, background, ball, beep, canvas, cpu, ctx, draw, getAnimationFrame, player, plop,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  canvas = document.getElementById("game");

  GAME_HEIGHT = canvas.height;

  GAME_WIDTH = canvas.width;

  GUTTER = 20;

  ctx = canvas.getContext("2d");

  Sprite = (function() {

    function Sprite(path, context, x, y, speed) {
      var _this = this;
      this.path = path;
      this.context = context;
      this.x = x;
      this.y = y;
      this.speed = speed;
      this.bounds = {
        left: 0,
        right: 0,
        top: 0,
        bottom: 0
      };
      this.image = new Image();
      this.image.src = this.path;
      this.image.onload = function() {
        _this.width = _this.image.width;
        _this.height = _this.image.height;
        _this.bounds.bottom = (GAME_HEIGHT - GUTTER) - _this.height;
        _this.bounds.right = GAME_WIDTH - _this.width;
        return _this.bounds.top = GUTTER;
      };
    }

    Sprite.prototype.draw = function() {
      return this.context.drawImage(this.image, this.x, this.y);
    };

    Sprite.prototype.collides = function(item) {
      var bottom1, bottom2, left1, left2, right1, right2, top1, top2;
      left1 = this.x;
      left2 = item.x;
      right1 = this.x + this.width;
      right2 = item.x + item.width;
      top1 = this.y;
      top2 = item.y;
      bottom1 = this.y + this.height;
      bottom2 = item.y + item.height;
      if (bottom1 < top2 || top1 > bottom2 || right1 < left2 || left1 > right2) {
        return false;
      }
      return true;
    };

    return Sprite;

  })();

  Paddle = (function(_super) {

    __extends(Paddle, _super);

    function Paddle() {
      Paddle.__super__.constructor.apply(this, arguments);
    }

    Paddle.prototype.move = function(y) {
      if (y > this.bounds.top && y < this.bounds.bottom) return this.y = y;
    };

    return Paddle;

  })(Sprite);

  Ball = (function(_super) {

    __extends(Ball, _super);

    function Ball() {
      this.velocity = {
        x: 1,
        y: 1
      };
      Ball.__super__.constructor.apply(this, arguments);
    }

    Ball.prototype.move = function() {
      this.x += this.speed * this.velocity.x;
      return this.y += this.speed * this.velocity.y;
    };

    Ball.prototype.draw = function() {
      if (this.collides(cpu)) {
        this.x = cpu.x - this.width;
        this.velocity.x *= -1;
        beep.play();
      }
      if (this.collides(player)) {
        this.x = (player.x + player.width) - 1;
        this.velocity.x *= -1;
        beep.play();
      }
      if (this.y < this.bounds.top || this.y > this.bounds.bottom) {
        this.velocity.y *= -1;
        plop.play();
      }
      return Ball.__super__.draw.apply(this, arguments);
    };

    return Ball;

  })(Sprite);

  Sound = (function() {

    function Sound(path) {
      this.path = path;
      this.sound = new Audio();
      this.sound.src = this.path;
    }

    Sound.prototype.play = function() {
      return this.sound.play();
    };

    return Sound;

  })();

  background = new Sprite("images/background.png", ctx, 0, 0);

  player = new Paddle("images/player.png", ctx, 20, (GAME_HEIGHT / 2) - 30);

  cpu = new Paddle("images/player.png", ctx, (GAME_WIDTH - 14) - 20, (GAME_HEIGHT / 2) - 30);

  ball = new Ball("images/ball.png", ctx, (GAME_WIDTH / 2) - 8, (GAME_HEIGHT / 2) - 8, 5);

  beep = new Sound("audio/beep.ogg");

  plop = new Sound("audio/plop.ogg");

  draw = function() {
    background.draw();
    player.draw();
    cpu.draw();
    ball.draw();
    ball.move();
    cpu.move(ball.y);
    return getAnimationFrame()(draw, canvas);
  };

  setInterval(function() {
    return ball.speed += .2;
  }, 1000);

  getAnimationFrame = function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  };

  document.body.addEventListener('mousemove', function(event) {
    return player.move(event.y - (player.height / 2));
  }, false);

  draw();

}).call(this);
