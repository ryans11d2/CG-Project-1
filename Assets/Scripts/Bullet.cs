using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {

        if (collision.gameObject.tag == "Player") collision.gameObject.GetComponent<Player>().Shot();
        if (collision.gameObject.tag == "Guard") collision.gameObject.GetComponent<Guard>().Shot();
        if (collision.gameObject.tag == "Switch") collision.gameObject.GetComponent<Switch>().Shot();
        if (collision.gameObject.tag == "Terminal") collision.gameObject.GetComponent<Terminal>().Shot();

        Destroy(gameObject);
    }

}
