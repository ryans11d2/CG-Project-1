using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Switch : MonoBehaviour
{
    [SerializeField] GameObject[] Activate;
    [SerializeField] float duration = 4.0f;
    [SerializeField] GameObject[] flash;
    float active = 0;
    float timer = 0;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        if (timer > 0)
        {
            timer -= Time.deltaTime;
            for (int i = 0; i < Activate.Length; i++)
            {
                Activate[i].SetActive(false);
            }
            active = timer / duration;
        }
        else
        {
            //timer -= Time.deltaTime;
            for (int i = 0; i < Activate.Length; i++)
            {
                Activate[i].SetActive(true);
            }
            active = 0;
        }

        foreach (GameObject go in flash)
        {
            go.GetComponent<Renderer>().material.SetFloat("_Timer", active);
        }
        

    }

    public void Shot()
    {
        timer = duration;
    }

}
