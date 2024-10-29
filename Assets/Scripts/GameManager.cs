using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEditor.Timeline;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{

    public bool power = true;
    public bool alarm = false;
    private Animator animator;

    private float countdown = 60.0f;
    private float red = 1.0f;
    [SerializeField] private Text CountdownText;

    public bool objective = false;

    void Start()
    {
        animator = GetComponent<Animator>();
        CountdownText.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        //if (Input.GetKeyDown(KeyCode.X)) alarm = !alarm;

        animator.SetBool("Power", power);
        animator.SetBool("Alarm", alarm);

        if (alarm && countdown > 0)
        {
            countdown -= Time.deltaTime;
            CountdownText.enabled = true;

            CountdownText.text = (countdown % 60).ToString() + (countdown / 60).ToString();

            if (red < 1.0f) red = Mathf.MoveTowards(red, 1, 2 * Time.deltaTime);
            CountdownText.color = new Color(red, 0, 0);

        }

        if (countdown < 0)
        {
            SceneManager.LoadScene("GameOver");
        }


    }

    public void SetPower(bool new_power)
    {
        power = new_power;
    }

    public void Alert()
    {
        if (!alarm) alarm = true;
        else countdown -= 5;

        red = 0;

    }

}
