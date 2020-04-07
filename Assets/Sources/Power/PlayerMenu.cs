using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;

public class PlayerMenu : MonoBehaviour
{
    private Vector3 direction;
    public string horizontalAxis = "";
    public string verticalAxis = "";
    public string fire = "";
    public bool pressFire { get; private set; }
    public float speed;
    public int playerId = 0;

    public StartButton startButton;

    // Start is called before the first frame update
    void Start()
    {
        //
    }

    private void Update()
    {
        //
    }

    public void Move(InputAction.CallbackContext context)
    {
        direction = context.ReadValue<Vector2>();
    }

    public void Fire(InputAction.CallbackContext context)
    {
        pressFire = true;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        Vector3 newPositon = transform.position + (direction * speed * Time.deltaTime);
        Vector3 newScreenPosition = Camera.main.WorldToScreenPoint(newPositon);

        if (newScreenPosition.x > 0f && newScreenPosition.x < Screen.width &&
            newScreenPosition.y > 0f && newScreenPosition.y < Screen.height)
        {
            transform.position = newPositon;
        }


        var hits = Physics.RaycastAll(transform.position, transform.forward, 100f);


        bool aboveStart = false;

        for (int i = 0; i < hits.Length; i++)
        {
            if (hits[i].collider.gameObject.CompareTag("buttonstart"))
            {
                aboveStart = true;
            }
        }

        if (aboveStart)
        {
            if (pressFire == true)
            {
                startButton?.PlayerPress(playerId);
            }
        }

        pressFire = false;
    }
}
