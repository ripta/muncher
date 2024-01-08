import std.random;
import std.stdio;
import std.string;

import raylib;

enum Mode {
	Menu,
	Play,
	Pause,
	Death,
	Quit,
}

enum Move {
	Left,
	Right,
	Up,
	Down,
}

struct Apple {
	Rectangle pos;
	bool eaten = true;

	void jump() {
		int nx = uniform(0, 40) * 16;
		int ny = uniform(0, 30) * 16;
		pos = Rectangle(nx, ny, 16, 16);
	}

	void update() {
		if (eaten) {
			jump();
			eaten = false;
		}
	}

	void render() {
		if (eaten) {
			return;
		}
		DrawRectangleRec(pos, Colors.RED);
	}
}

struct Player {
	Rectangle[64] poss = Rectangle(-16, -16, 16, 16);
	Move move = Move.Right;

	int size = 1;

	this(int x, int y) {
		poss[0] = Rectangle(x, y, 16, 16);
	}

	bool coiled() {
		for (int i = 1; i < size; i++) {
			if (poss[i].x == poss[0].x && poss[i].y == poss[0].y) {
				return true;
			}
		}
		return false;
	}

	void grow() {
		size++;
	}

	void update() {
		for (int i = size; i > 0; i--) {
			poss[i].x = poss[i-1].x;
			poss[i].y = poss[i-1].y;
		}

		if (move == Move.Left) {
			poss[0].x -= 16;
		} else if (move == Move.Right) {
			poss[0].x += 16;
		} else if (move == Move.Up) {
			poss[0].y -= 16;
		} else if (move == Move.Down) {
			poss[0].y += 16;
		}

		if (poss[0].x < 0) {
			poss[0].x = 624;
		} else if (poss[0].x > 640) {
			poss[0].x = 16;
		} else if (poss[0].y < 0) {
			poss[0].y = 464;
		} else if (poss[0].y > 480) {
			poss[0].y = 16;
		}
	}

	void render() {
		for (int i = 0; i < size; i++) {
			DrawRectangleRec(poss[i], Colors.BLUE);
		}
	}
}

struct Game {
	Mode mode = Mode.Menu;
	Player snake = Player(320, 240); // middle of screen
	Apple apple = Apple();

	//bool died = false;
	double tick = 0;
	double score = 0;

	this(string name) {
		InitWindow(640, 480, name.toStringz);
		SetTargetFPS(30);
	}

	~this() {
		CloseWindow();
	}

	void handleEvent() {
		if (WindowShouldClose()) {
			mode = Mode.Quit;
		} else if (IsKeyPressed(KeyboardKey.KEY_ESCAPE)) {
			mode = Mode.Quit;
		} else if (IsKeyPressed(KeyboardKey.KEY_LEFT)) {
			snake.move = Move.Left;
		} else if (IsKeyPressed(KeyboardKey.KEY_RIGHT)) {
			snake.move = Move.Right;
		} else if (IsKeyPressed(KeyboardKey.KEY_UP)) {
			snake.move = Move.Up;
		} else if (IsKeyPressed(KeyboardKey.KEY_DOWN)) {
			snake.move = Move.Down;
		}
	}

	void update() {
		if (mode == Mode.Death) {
			return;
		}

		tick += GetFrameTime();
		if (tick < 0.125) {
			return;
		}

		tick = 0;

		if (snake.coiled()) {
			writeln("Died");
			mode = Mode.Death;
		}

		if (snake.poss[0].x == apple.pos.x && snake.poss[0].y == apple.pos.y) {
			apple.eaten = true;
			snake.grow();
		}

		apple.update();
		snake.update();
	}

	void render() {
		BeginDrawing();
		ClearBackground(Colors.BLACK);

		apple.render();
		snake.render();

		if (mode == Mode.Death) {
			//DrawRectangle(0, 0, 640, 480, Color(0, 0, 0, 150));
			DrawText("Game Over", 30, 240, 48, Colors.WHITE);
		} else if (mode == Mode.Menu) {
			DrawText("Hit Enter to Start", 30, 240, 48, Colors.WHITE);
		}

		DrawFPS(10, 10);
		EndDrawing();
	}
}

void main() {
	Game g = Game("muncher");
	g.mode = Mode.Menu;
	while (g.mode != Mode.Quit) {
		g.handleEvent();
		g.update();
		g.render();
	}
}
