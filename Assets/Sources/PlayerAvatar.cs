using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAvatar : MonoBehaviour
{
    // Start is called before the first frame update

    public GameObject prefab;
    public float speed;

    public string horizontalAxis = "";
    public string verticalAxis = "";
    public string fire = "";

    private Vector3 direction;

    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        direction = new Vector3(
            Input.GetAxis(horizontalAxis),
            Input.GetAxis(verticalAxis),
            0f
        );

        direction.Normalize();

    }

    private void FixedUpdate()
    {
        transform.Translate(direction * speed * Time.deltaTime);
    }

    /*
    public void OnMove(InputAction.CallbackContext context)
    {
        var vector2 = context.ReadValue<Vector2>();
        direction = new Vector3(vector2.x, vector2.y, 0f);
    }

    public void Fire(InputAction.CallbackContext context)
    {
        Debug.Log(gameObject.name +   " Fire!");
    }
    */
}
