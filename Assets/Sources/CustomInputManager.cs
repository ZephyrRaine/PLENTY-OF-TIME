using System;
using System.Collections;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Users;
public class CustomInputManager : MonoBehaviour
{
    public PlayerInput[] players;
    private int gamepadassigned = 0;

    // Start is called before the first frame update
    IEnumerator Start()
    {
        yield return null;

        foreach (PlayerInput playerInput in PlayerInput.all)
        {
            if (playerInput.user.valid == false)
            {
                InputUser user = InputUser.CreateUserWithoutPairedDevices();
            }
        }

        Assign();

        if (gamepadassigned < players.Length)
            InputSystem.onDeviceChange += DeviceChangedHandler;
    }


    void DeviceChangedHandler(InputDevice device, InputDeviceChange change)
    {
        if (gamepadassigned < players.Length)
            Assign();
    }

    void Assign()
    {
        var gamepads = Gamepad.all;
        int limit = Math.Min(players.Length, gamepads.Count);
        int start = gamepadassigned;

        for (int i = 0; i < limit; i++)
        {
            InputUser.PerformPairingWithDevice(gamepads[i], InputUser.all[players[i].playerIndex], InputUserPairingOptions.UnpairCurrentDevicesFromUser);
            InputUser.PerformPairingWithDevice(Keyboard.current, InputUser.all[players[i].playerIndex]);

            players[i].SwitchCurrentControlScheme("Gamepad", gamepads[i], Keyboard.current);
            players[i].defaultActionMap = "Player"+(i+1);

            UnityEngine.Debug.Log("Assign " + gamepads[i].name + " to " + players[i].name + " with " + "Player" + (i + 1));
            gamepadassigned++;
        }
    }
}
