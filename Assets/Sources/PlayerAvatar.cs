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

    public bool pressFire { get; private set; }

    private SunCollider _sun;
    private Canvas _canvas;

    void Start()
    {
        _sun = GameObject.FindObjectOfType<SunCollider>();
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
                _curFeedback.OnPlayerExit(player);
            }
            _curFeedback = value;


            _curFeedback?.OnPlayerEnter(player);
        }
    }

    void Update()
    {
        direction.x = Input.GetAxis(horizontalAxis);
        direction.y = Input.GetAxis(verticalAxis);
        direction.z = 0f;

        direction.Normalize();

        if (Input.GetButtonDown(fire))
        {
            pressFire = true;
        }
    }

    private void FixedUpdate()
    {
        transform.Translate(direction * speed * Time.deltaTime);

        // Physics

        // Check Feedback
        PointerEventData pointerData = new PointerEventData(EventSystem.current);
        pointerData.position = Camera.main.WorldToScreenPoint(transform.position);
        List<RaycastResult> results = new List<RaycastResult>();
        EventSystem.current.RaycastAll(pointerData, results);

        if (results.Count > 0)
        {
            UIFeedback fb = results[0].gameObject.GetComponent<UIFeedback>();

            if (fb != null)
            {
                RectTransform fbRect = fb.image.GetComponent<RectTransform>();
                Vector3 fbPosition = fbRect.position;
                float widht = fbRect.rect.width * fb.parentCanvas.scaleFactor;
                float distance = Vector2.Distance(pointerData.position, fbPosition);

                if (distance <= (widht /2f))
                {
                    curFeedback = fb;                    
                }
                else
                {
                    curFeedback = null;
                }

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

        if (curFeedback != null && pressFire)
        {
            curFeedback.Activate(player);
        }

        // Check suncollider

        RaycastHit hitInfo;

        if (Physics.Raycast(Camera.main.transform.position,
            _sun.transform.position - Camera.main.transform.position, 
            out hitInfo, 
            1000f, 
            LayerMask.NameToLayer("PERSO")))
        {
            PlayerAvatar m = hitInfo.transform.GetComponent<PlayerAvatar>();
                        
            if (m != null && m.player.playerId == this.player.playerId && pressFire)
            {
                _sun.p.Launch(player, player.opponent, 0);
            }
        }

        pressFire = false;
    }
}
