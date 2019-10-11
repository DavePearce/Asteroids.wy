/**
 * Status of each key (either pressed or not)
 */
public type State is (bool[] status)
where |status| == 127

public final int SPACEBAR = 0x20

public final int LEFTARROW = 0x25
public final int UPARROW = 0x26
public final int RIGHTARROW = 0x27
public final int DOWNARROW = 0x28

public final int ZERO = 0x30
public final int ONE = 0x31
public final int TWO = 0x32
public final int THREE = 0x33
public final int FOUR = 0x34
public final int FIVE = 0x35
public final int SIX = 0x36
public final int SEVEN = 0x37
public final int EIGHT = 0x38
public final int NINE = 0x39

public final int A = 0x41
public final int B = 0x42
public final int C = 0x43
public final int D = 0x44
public final int E = 0x45
public final int F = 0x46
public final int G = 0x47
public final int H = 0x48
public final int I = 0x49
public final int J = 0x4A
public final int K = 0x4B
public final int L = 0x4C
public final int M = 0x4D
public final int N = 0x4E
public final int O = 0x4F
public final int P = 0x50
public final int Q = 0x51
public final int R = 0x52
public final int S = 0x53
public final int T = 0x54
public final int U = 0x55
public final int V = 0x56
public final int W = 0x57
public final int X = 0x58
public final int Y = 0x59
public final int Z = 0x5A

public export function init() -> State:
    return [false; 127]


