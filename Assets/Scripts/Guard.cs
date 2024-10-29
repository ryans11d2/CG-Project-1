using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Guard : MonoBehaviour
{

    [SerializeField] GameManager manager;
    [SerializeField] Room room;
    [SerializeField] Player player;
    [SerializeField] Transform aim;
    [SerializeField] Transform look;
    NavMeshAgent agent;

    LineRenderer PatrolPoints;
    [SerializeField] int PatrolIndex = 0;
    Vector3 Point = Vector3.zero;
    Vector3 StartPos;

    bool chase = false;
    bool sight = false;

    float spot = 10;

    int health = 4;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        PatrolPoints = GetComponent<LineRenderer>();
        StartPos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {

        if (manager.alarm) ;
        else
        {
            transform.position = StartPos;
        }

        aim.transform.LookAt(player.transform.position);
        look.transform.LookAt(new Vector3(agent.destination.x, transform.position.y, agent.destination.z));
        //Debug.Log(aim.transform.eulerAngles.y - transform.eulerAngles.y);
        
        if (Physics.Raycast(transform.position, aim.transform.forward, out RaycastHit hit, 20))
        {
            if (hit.collider.gameObject.tag == "Player") sight = true;
        }

        float dist = Vector3.Distance(transform.position, player.transform.position);

        if (manager.power) spot = 10;
        else spot = 6;

        if (Quaternion.Angle(transform.rotation, aim.rotation) < 30 && dist < spot) chase = true;

        if (chase)
        {
            agent.stoppingDistance = 8;
            agent.SetDestination(player.transform.position);

            if (dist <= 8 && sight) transform.rotation = Quaternion.RotateTowards(transform.rotation, aim.rotation, 180 * Time.deltaTime);

        }
        else
        {
            agent.stoppingDistance = 0.5f;
            if (Quaternion.Angle(transform.rotation, look.rotation) > 5) transform.rotation = Quaternion.RotateTowards(transform.rotation, look.rotation, 180 * Time.deltaTime);
            else NextPoint();
        }
        

    }

    void NextPoint()
    {
        if (agent.remainingDistance <= agent.stoppingDistance) PatrolIndex++;
        if (PatrolIndex >= PatrolPoints.positionCount) PatrolIndex = 0;

        Point = PatrolPoints.GetPosition(PatrolIndex);

        agent.SetDestination(Point + StartPos);

    }

    public void Shot()
    {
        chase = true;
        health -= 1;
        if (health <= 0) Destroy(gameObject);
    }

}
