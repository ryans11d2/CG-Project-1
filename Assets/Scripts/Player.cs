using System.Collections;
using System.Collections.Generic;
using UnityEditor.Rendering;
using UnityEngine;
using UnityEngine.UI;

public class Player : MonoBehaviour
{

    [SerializeField] GameCamera cam;
    [SerializeField] GameObject stand;
    [SerializeField] Transform look;
    [SerializeField] GameObject bullet;
    [SerializeField] GameObject laser;
    GameObject tex;
    Animator animator;
    Rigidbody rb;

    public Vector2 FrameCoords = Vector2.zero;
    public int FrameY;

    [Header("Movement")]
    [SerializeField] float Speed = 120.0f;
    [SerializeField] float MaxSpeed = 80.0f;
    [SerializeField] float Drag = 160.0f;
    [SerializeField] float Crouch = 0.6f;
    private Vector3 MoveDir = Vector3.zero;
    private Vector3 Velocity = Vector3.zero;
    private bool Crouching = false;

    [Header("Shooting")]
    [SerializeField] int MaxAmmo = 6;
    [SerializeField] int Reloads = 1;
    [SerializeField] float ShootDelay = 0.5f;
    [SerializeField] float ReloadDelay = 5.0f;
    private int Ammo;
    private float ShootTimer = 0;
    private float ReloadTimer = 0;
    private bool BeamOn = true;

    public float frame = 0;

    [Header("UI")]
    [SerializeField] Image AmmoUI;
    [SerializeField] Image ReloadUI;

    void Start()
    {
        PlayerInputs.Init(this);
        animator = GetComponent<Animator>();
        rb = GetComponent<Rigidbody>();
        tex = stand;

        Ammo = MaxAmmo;

    }

    void Update()
    {
        Crouching = Input.GetKey(KeyCode.LeftShift);

        AmmoUI.fillAmount = Ammo / 6.0f;
        AmmoUI.enabled = true;

        if (ReloadTimer > 0)
        {
            ReloadTimer -= Time.deltaTime;
            ReloadUI.fillAmount = 1 - ReloadTimer / ReloadDelay;
            AmmoUI.enabled = false;
            ReloadUI.enabled = true;
        }
        else if (ShootTimer > 0)
        {
            ShootTimer -= Time.deltaTime;
            ReloadUI.fillAmount = 1 - ShootTimer / ShootDelay;
            AmmoUI.enabled = true;
            ReloadUI.enabled = true;
        }
        else
        {
            ReloadUI.enabled = false;
        }
 


    }

    private void FixedUpdate()
    {

        tex.transform.rotation = Quaternion.Euler(new Vector3(cam.transform.rotation.x, 0, 0));

        //look = Vector3.SignedAngle(transform.position, cam.look, Vector3.forward);
        look.LookAt(cam.look);
        laser.transform.LookAt(new Vector3(cam.look.x, laser.transform.position.y, cam.look.z));
        frame = 8 - (int)((look.localRotation.eulerAngles.y + 191.25f) / 180.0f * 4);

        if (MoveDir.magnitude != 0)
        {
            Velocity = Vector3.Lerp(Velocity, MoveDir.normalized * Speed, Time.deltaTime);
            animator.SetBool("Walk", true);
        }
        else
        {
            Velocity = Vector3.Lerp(Velocity, Vector3.zero, Drag * Time.deltaTime);
            animator.SetBool("Walk", false);
        }

        if (Velocity.magnitude > MaxSpeed) Velocity = Velocity.normalized * MaxSpeed;

        //if (Crouching) Velocity *= Crouch;
        animator.SetBool("Crouch", Crouching);

        if (cam.LUT == cam.GreenLUT)
        {
            stand.transform.eulerAngles = new Vector3(90, 0, 0);
            FrameY = 0;
        }
        else stand.transform.eulerAngles = new Vector3(0.53f, 0, 0);

        FrameCoords = new Vector2(0.125f * (float)frame, 0.2f * (float)FrameY);
        tex.gameObject.GetComponent<Renderer>().material.SetTextureOffset("_MainTex", FrameCoords);

        transform.position += Velocity * Time.deltaTime;

    }

    public void Move(Vector3 dir)
    {
        MoveDir = dir;
    }

    public void Shoot()
    {

        if (ShootTimer > 0 || ReloadTimer > 0) return;

        ReloadUI.enabled = true;
        ShootTimer = ShootDelay;
        Ammo -= 1;

        GameObject newBullet = Instantiate(bullet);
        newBullet.transform.position = transform.position;
        newBullet.GetComponent<Rigidbody>().AddForce(look.transform.forward * 70, ForceMode.Impulse);

        Destroy(newBullet, 5);

        if (BeamOn) laser.GetComponentInChildren<Animator>().Play("Shoot");

        if (Ammo <= 0)
        {
            Reload();
        }

    }

    public void Reload()
    {
        if (Reloads <= 0) return;

        ReloadTimer = ReloadDelay;
        ShootTimer = 0;
        Ammo = MaxAmmo;
        //Reloads -= 1;

        if (BeamOn) laser.GetComponentInChildren<Animator>().Play("Reload");

    }

    public void ToggleBeam()
    {
        BeamOn = !BeamOn;
        laser.GetComponentInChildren<Animator>().SetBool("On", BeamOn);
    }

    public void Shot()
    {
        Debug.Log("Shot");
    }

}
