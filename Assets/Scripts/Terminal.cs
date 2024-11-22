using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Terminal : MonoBehaviour
{
    [SerializeField] GameManager manager;
    [SerializeField] Text exitText;
    [SerializeField] Image dataImage;
    void Start()
    {
        exitText.enabled = false;
        dataImage.enabled = false;
    }

    public void Shot()
    {
        manager.Alert();
        manager.objective = true;
        exitText.enabled = true;
        dataImage.enabled = true;
    }

}
