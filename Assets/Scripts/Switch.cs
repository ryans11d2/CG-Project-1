using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Switch : MonoBehaviour
{
    [SerializeField] GameObject[] Activate;
    [SerializeField] float duration = 4.0f;
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
            gameObject.GetComponent<Renderer>().material.SetColor("_Color", Color.black);
        }
        else
        {
            //timer -= Time.deltaTime;
            for (int i = 0; i < Activate.Length; i++)
            {
                Activate[i].SetActive(true);
            }
            gameObject.GetComponent<Renderer>().material.SetColor("_Color", Color.red);
        }

       gameObject.GetComponent<Renderer>().material.SetColor("_Color", new Color(1.0f - timer / duration, 0, 0, 0));

    }

    public void Shot()
    {
        timer = duration;
    }

}
