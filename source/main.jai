#import "Basic";
#import "Input";
#import "System";
#import "Windows";  

VOLUME_UP_SCAN_CODE :: 0xB0;
APP_NAME :: "Volume Up Key Blocker";

main :: () {
    print("Starting %...\n", APP_NAME);
    print("This program will block Volume Up key presses.\n");
    print("Press Ctrl+C to exit.\n\n");

    keyboard_hook := SetWindowsHookExA(
        13,
        xx keyboard_hook_procedure,
        null,
        0
    );

    if keyboard_hook == null {
        print("Failed to set keyboard hook. Error code: %\n", GetLastError());
        return;
    }

    msg: MSG;
    while GetMessageA(*msg, null, 0, 0) {
        TranslateMessage(*msg);
        DispatchMessageA(*msg);
    }

    UnhookWindowsHookEx(keyboard_hook);
}

keyboard_hook_procedure :: (code: s32, wparam: WPARAM, lparam: LPARAM) -> LRESULT #c_call {
    push_context,defer_pop;
    if code >= 0 {
        kb := cast(*KBDLLHOOKSTRUCT) lparam;
        
        if kb.scanCode == VOLUME_UP_SCAN_CODE {
            print("Blocked Volume Up key event\n"); //this never trigets, therefore is not a hardware problem (I guess)
            // Return non-zero to block the key
            return 1;  
        }

        
        if kb.vkCode == VK_VOLUME_UP {
            // print("Blocked Volume Up key event (by vkCode)\n"); This means that is a windows 11 problem.
            // Return non-zero to block the key
            return 1;
        }
    }
    
    return CallNextHookEx(null, code, wparam, lparam);
}

KBDLLHOOKSTRUCT :: struct {
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: LPCSTR;
}
