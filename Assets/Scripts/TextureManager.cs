using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureManager : MonoBehaviour
{
    private float active = 1.0f;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T)) 
        {
            if (active == 1.0f) active = 0.0f;
            else active = 1.0f;
            gameObject.GetComponent<Renderer>().material.SetFloat("_Active", active);
        }
    }
}
