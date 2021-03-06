﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;

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

            if(_curFeedback != null)
            {
                _curFeedback.OnPlayerEnter(player);
            }
        }
    }

    void Update()
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

    private void FixedUpdate()
    {
        //

        Vector3 newPositon = transform.position + (direction * speed * Time.deltaTime);
        Vector3 newScreenPosition = Camera.main.WorldToScreenPoint(newPositon);

        if (newScreenPosition.x > 0f && newScreenPosition.x < Screen.width &&
            newScreenPosition.y > 0f && newScreenPosition.y < Screen.height)
        {
            transform.position = newPositon;
        }

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
                if (fb.checkDeadZone == true)
                {
                    RectTransform fbRect = fb.image.GetComponent<RectTransform>();
                    Vector3 fbPosition = fbRect.position;
                    float widht = fbRect.rect.width * fb.parentCanvas.scaleFactor;
                    float distance = Vector2.Distance(pointerData.position, fbPosition);

                    if (distance <= (widht / 2f))
                    {
                        curFeedback = fb;
                    }
                    else
                    {
                        curFeedback = null;
                    }
                }
                else
                {
                    curFeedback = fb;
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
                _sun.fuck.SetActive(true);

            if (m != null && m.player.playerId == this.player.playerId && _sun.enabled)
            {
                if(pressFire)
                {
                    _sun.p.Launch(player, player.opponent, 0);

                    FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/sun-influence");
                    FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/moon-influence");

                    if (this.player.playerId == 1)
                    {
                        FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/good-stinger");
                    }
                    else
                    {
                        FMODUnity.RuntimeManager.PlayOneShot("event:/SFX/evil-stinger");
                    }
                }
            }
        }
        else
        {
            _sun.fuck.SetActive(false);
        }

        pressFire = false;
    }
}
