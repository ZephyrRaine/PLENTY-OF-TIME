using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class PlayerAvatar : MonoBehaviour
{
    // Start is called before the first frame update

    //To Setup correcly
    public Player player;
    public float speed;

    public string horizontalAxis = "";
    public string verticalAxis = "";
    public string fire = "";

    private Vector3 direction;

    void Start()
    {

    }

    UIFeedback _curFeedback;

    UIFeedback curFeedback
    {
        get
        {
            return _curFeedback;
        }
        set
        {
            if (_curFeedback != null && _curFeedback != value)
            {
                _curFeedback.Hide();
            }
            _curFeedback = value;


            _curFeedback?.Toggle(player);
        }
    }

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

        // Physics

        PointerEventData pointerData = new PointerEventData(EventSystem.current);
        pointerData.position = Camera.main.WorldToScreenPoint(transform.position);
        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(pointerData, results);

        if (results.Count > 0)
        {
            UIFeedback fb = results[0].gameObject.GetComponent<UIFeedback>();
            if (fb != null)
            {
                curFeedback = fb;
                results.Clear();
            }
            else
            {
                curFeedback = null;
            }
        }
        else
        {
            curFeedback = null;
        }

        if (curFeedback != null && Input.GetButtonDown(fire))
        {
            curFeedback.Activate(player);
        }
    }
}
