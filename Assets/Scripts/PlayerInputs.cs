using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInputs : MonoBehaviour
{

    private static PlayerControls _controls;

    public static void Init(Player player)
    {

        _controls = new PlayerControls();

        _controls.Game.Enable();

        Debug.Log(player);

        _controls.Game.Move.performed += ctx =>
        {
            player.Move(ctx.ReadValue<Vector3>());
        };

        _controls.Game.Action.performed += ctx =>
        {
            player.Shoot();
        };

        _controls.Game.Beam.started += ctx =>
        {
            player.ToggleBeam();
        };
        
    }

}
