using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Screen : MonoBehaviour
{
    [SerializeField] Vector2 RangeX = new Vector2(0, 1);
    [SerializeField] Vector2 RangeY = new Vector2(0, 1);
    [SerializeField] Vector2 Speed = Vector2.one;

    private Vector2 pos = Vector2.zero;
    private Vector2 dir = Vector2.one;

    void Start()
    {
        
    }

    void Update()
    {
        if (pos.x < RangeX.x)
        {
            dir.x = 1;
        }
        if (pos.x > RangeX.y)
        {
            dir.x = -1;
        }

        pos.x += dir.x * Speed.x * Time.deltaTime;

        gameObject.GetComponent<Renderer>().material.SetFloat("_OffX", pos.x);

        if (pos.y < RangeY.x)
        {
            dir.y = 1;
        }
        if (pos.y > RangeY.y)
        {
            dir.y = -1;
        }

        pos.y += dir.y * Speed.y * Time.deltaTime;

        gameObject.GetComponent<Renderer>().material.SetFloat("_OffY", pos.y);

    }
}
