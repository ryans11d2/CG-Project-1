using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureManager : MonoBehaviour
{
    private float active = 1.0f;

    [SerializeField] KeyCode ToggleKey = KeyCode.T;
    void Update()
    {
        if (Input.GetKeyDown(ToggleKey) || Input.GetKeyDown(KeyCode.T))
        {
            if (active == 1.0f) active = 0.0f;
            else active = 1.0f;
            gameObject.GetComponent<Renderer>().material.SetFloat("_Active", active);
        }
    }
}
