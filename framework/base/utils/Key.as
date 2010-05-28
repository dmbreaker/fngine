package base.utils
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public final class Key
	{
		// ============================================================
		// ============================================================
		public function Key() {}
		// ============================================================
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		
		public static const Keyb0:int = 48;
		public static const Keyb1:int = 49;
		public static const Keyb2:int = 50;
		public static const Keyb3:int = 51;
		public static const Keyb4:int = 52;
		public static const Keyb5:int = 53;
		public static const Keyb6:int = 54;
		public static const Keyb7:int = 55;
		public static const Keyb8:int = 56;
		public static const Keyb9:int = 57;
		
		public static const Numpad0:int = 96;
		public static const Numpad1:int = 97;
		public static const Numpad2:int = 98;
		public static const Numpad3:int = 99;
		public static const Numpad4:int = 100;
		public static const Numpad5:int = 101;
		public static const Numpad6:int = 102;
		public static const Numpad7:int = 103;
		public static const Numpad8:int = 104;
		public static const Numpad9:int = 105;
		
		public static const NumpadStar:int = 106;
		public static const NumpadPlus:int = 107;
		public static const NumpadMinus:int = 109;
		public static const NumpadPeriod:int = 110;
		public static const NumpadSlash:int = 111;
		
		public static const F1 :int = 112;
		public static const F2 :int = 113;
		public static const F3 :int = 114;
		public static const F4 :int = 115;
		public static const F5 :int = 116;
		public static const F6 :int = 117;
		public static const F7 :int = 118;
		public static const F8 :int = 119;
		public static const F9 :int = 120;
		public static const F11:int = 122;
		public static const F12:int = 123;
		public static const F13:int = 124;
		public static const F14:int = 125;
		public static const F15:int = 126;
		
		public static const Backspace :int = 8;		// BACKSPACE
		public static const Tab       :int = 9;
		public static const Lf        :int = 10;	// \n
		public static const NewLine   :int = 10;	// \n
		public static const Enter     :int = 13;	// ENTER
		public static const Cr        :int = 13;
		public static const Shift     :int = 16;
		public static const Control   :int = 17;
		public static const PauseBreak:int = 19;
		public static const CapsLock  :int = 20;
		public static const Esc       :int = 27;	// ESCAPE
		public static const Spacebar  :int = 32;	// SPACE
		public static const PageUp    :int = 33;
		public static const PageDown  :int = 34;
		public static const End       :int = 35;
		public static const Home      :int = 36;
		public static const Left      :int = 37;	// LEFT
		public static const Up        :int = 38;	// UP
		public static const Right     :int = 39;	// RIGHT
		public static const Down      :int = 40;	// DOWN
		public static const Insert    :int = 45;
		public static const Delete    :int = 46;
		
		public static const NumLck     :int = 144;
		public static const ScrLck     :int = 145;
		public static const SemiColon  :int = 186;
		public static const Equal      :int = 187;
		public static const Comma      :int = 188;
		public static const Minus      :int = 189;
		public static const Period     :int = 190;
		public static const Question   :int = 191;
		public static const BackQuote  :int = 192;
		public static const LeftBrace  :int = 219;
		public static const Pipe       :int = 220;
		public static const RightBrace :int = 221;
		public static const SingleQuote:int = 222;
		// ============================================================
		public static const keyName:Array = new Array();
		// ============================================================
		keyName[A] = "A";
		keyName[B] = "B";
		keyName[C] = "C";
		keyName[D] = "D";
		keyName[E] = "E";
		keyName[F] = "F";
		keyName[G] = "G";
		keyName[H] = "H";
		keyName[I] = "I";
		keyName[J] = "J";
		keyName[K] = "K";
		keyName[L] = "L";
		keyName[M] = "M";
		keyName[N] = "N";
		keyName[O] = "O";
		keyName[P] = "P";
		keyName[Q] = "Q";
		keyName[R] = "R";
		keyName[S] = "S";
		keyName[T] = "T";
		keyName[U] = "U";
		keyName[V] = "V";
		keyName[W] = "W";
		keyName[X] = "X";
		keyName[Y] = "Y";
		keyName[Z] = "Z";

		keyName[Keyb0] = "0";
		keyName[Keyb1] = "1";
		keyName[Keyb2] = "2";
		keyName[Keyb3] = "3";
		keyName[Keyb4] = "4";
		keyName[Keyb5] = "5";
		keyName[Keyb6] = "6";
		keyName[Keyb7] = "7";
		keyName[Keyb8] = "8";
		keyName[Keyb9] = "9";

		keyName[Numpad0] = "Numpad 0";
		keyName[Numpad1] = "Numpad 1";
		keyName[Numpad2] = "Numpad 2";
		keyName[Numpad3] = "Numpad 3";
		keyName[Numpad4] = "Numpad 4";
		keyName[Numpad5] = "Numpad 5";
		keyName[Numpad6] = "Numpad 6";
		keyName[Numpad7] = "Numpad 7";
		keyName[Numpad8] = "Numpad 8";
		keyName[Numpad9] = "Numpad 9";

		keyName[NumpadStar]		= "Numpad *";
		keyName[NumpadPlus]		= "Numpad +";
		keyName[NumpadMinus]	= "Numpad -";
		keyName[NumpadPeriod]	= "Numpad .";
		keyName[NumpadSlash]	= "Numpad /";

		keyName[F1]		= "F1";
		keyName[F2]		= "F2";
		keyName[F3]		= "F3";
		keyName[F4]		= "F4";
		keyName[F5]		= "F5";
		keyName[F6]		= "F6";
		keyName[F7]		= "F7";
		keyName[F8]		= "F8";
		keyName[F9]		= "F9";
		keyName[F11]	= "F11";
		keyName[F12]	= "F12";
		keyName[F13]	= "F13";
		keyName[F14]	= "F14";
		keyName[F15]	= "F15";

		keyName[Backspace]	= "Backspace";
		keyName[Tab]		= "Tab";
		keyName[Enter]		= "Enter";
		keyName[Shift]		= "Shift";
		keyName[Control]	= "Control";
		keyName[PauseBreak]	= "Pause/Break";
		keyName[CapsLock]	= "Caps Lock";
		keyName[Esc]		= "Esc";
		keyName[Spacebar]	= "Spacebar";
		keyName[PageUp]		= "Page Up";
		keyName[PageDown]	= "Page Down";
		keyName[End]		= "End";
		keyName[Home]		= "Home";
		keyName[Left]		= "Left Arrow";
		keyName[Up]			= "Up Arrow";
		keyName[Right]		= "Right Arrow";
		keyName[Down]		= "Down Arrow";
		keyName[Insert]		= "Insert";
		keyName[Delete]		= "Delete";

		keyName[NumLck]			= "NumLck";
		keyName[ScrLck]			= "ScrLck";
		keyName[SemiColon]		= ";";
		keyName[Equal]			= "=";
		keyName[Comma]			= ",";
		keyName[Minus]			= "-";
		keyName[Period]			= ".";
		keyName[Question]		= "?";
		keyName[BackQuote]		= "`";
		keyName[LeftBrace]		= "[";
		keyName[Pipe]			= "|";
		keyName[RightBrace]		= "]";
		keyName[SingleQuote]	= "'";
		// ============================================================
	}
	
}