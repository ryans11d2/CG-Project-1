using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameCamera : MonoBehaviour
{

    [SerializeField] GameManager manager;

    private Transform pos;
    private Transform stand;
    private Transform crouch;
    public Vector3 look = Vector3.zero;

    [SerializeField] private float speed = 1.6f;

    public Material NoLUT;
    public Material GreenLUT;
    public Material AlarmLUT;
    public Material DarkLUT;
    public Material LUT = null;
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (LUT == GreenLUT) ;
        else if (manager.alarm) LUT = AlarmLUT;
        else if (!manager.power) LUT = DarkLUT;

        Graphics.Blit(source, destination, LUT);
    }

    void Start()
    {
        pos = transform;
    }

    void Update()
    {

        if (Input.GetKey(KeyCode.LeftShift)) pos = crouch;
        else pos = stand;

        if (Vector3.Distance(transform.position, pos.position) < 0.2f) transform.position = pos.position;
        else transform.position = Vector3.MoveTowards(transform.position, pos.position, speed * Time.deltaTime);

        //transform.rotation.x = Mathf.MoveTowards(transform.rotation.x, pos.rotation.x, speed * Time.deltaTime);

        transform.rotation = Quaternion.Lerp(transform.rotation, pos.transform.rotation, 15f * Time.deltaTime);

        if (Physics.Raycast(Camera.main.ScreenPointToRay(Mouse.current.position.value), out RaycastHit hit, 200))
        {
            Debug.DrawRay(hit.point, Vector3.up, Color.red, 2.0f);
            look = hit.point;
        }

    }

    public void SetPos(Transform new_pos, Transform new_crouch)
    {
        stand = new_pos;
        crouch = new_crouch;
    }

    public void SetGrade(int new_grade)
    {
        if (new_grade == 3) LUT = GreenLUT;
        else if (new_grade == 1) LUT = DarkLUT;
        else if (new_grade == 2) LUT = AlarmLUT;
        else LUT = NoLUT;
    }

}
