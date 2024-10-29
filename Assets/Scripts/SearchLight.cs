using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class SearchLight : MonoBehaviour
{

    [SerializeField] private GameManager manager;
    [SerializeField] private GameObject mover;
    [SerializeField] private float MoveSpeed = 1;
    [SerializeField] private float WaitTime = 0.0f;
    private float Timer = 0.0f;

    private LineRenderer line;

    private Vector3 Next;
    [SerializeField] private int Index = 0;



    void Start()
    {
        line = GetComponent<LineRenderer>();
        NextPosition();
        Next = line.GetPosition(Index);
        mover.transform.position = transform.position + Next;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void FixedUpdate()
    {

        if (mover.transform.position == transform.position + Next && Timer <= 0)
        {
            NextPosition();
        }
        else
        {
            if (Timer <= 0) mover.transform.position = Vector3.MoveTowards(mover.transform.position, transform.position + Next, MoveSpeed * Time.deltaTime);
            else Timer -= Time.deltaTime;
        }
    }

    void NextPosition()
    {
        Index++;
        if (Index >= line.positionCount) Index = 0;

        Next = line.GetPosition(Index);

        Timer += WaitTime;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (gameObject.tag == "Player" && manager.power)
        {
            manager.alarm = true;
        }
    }

}
