using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Room : MonoBehaviour
{
    [SerializeField] private GameManager manager;
    [SerializeField] private GameObject walls;
    [SerializeField] public bool Power = true;
    [SerializeField] private bool win = false;
    private bool Active = false;

    [Header("CAMERA")]
    [SerializeField] private GameCamera cam;
    [SerializeField] private Transform CamPoint;
    [SerializeField] private Transform CrouchPoint;
    [SerializeField] private bool follow = false;
    [SerializeField] private GameObject player = null;
    public enum Grading
    {
        none,
        cold,
        warm,
        cam
    }
    public Grading Grade;

    void Start()
    {
        walls.SetActive(false);
    }

    void Update()
    {
        /*
        if (Input.GetKeyDown(KeyCode.Z) && Active) {
            Power = !Power;
            manager.SetPower(Power);
        }
        */

        if (follow && player != null) CrouchPoint.transform.position = player.transform.position + new Vector3(1.1f, 0.9f, -1.2f);

    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            walls.SetActive(true);
            cam.SetPos(CamPoint.transform, CrouchPoint.transform);
            cam.SetGrade((int)Grade);
            manager.SetPower(Power);
            Active = true;

            if (win && manager.objective) SceneManager.LoadScene("Victory");

        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            walls.SetActive(false);
            Active = false;
        }
    }

}
