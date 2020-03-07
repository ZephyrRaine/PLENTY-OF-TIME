using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class Move : MonoBehaviour
{
    public KeyCode upKey;
    public KeyCode downKey;
    public KeyCode leftKey;
    public KeyCode rightKey;
    public KeyCode actionKey;

    public float speed;

    public bool isGood;
    public Player player;
    // Start is called before the first frame update
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
            if(_curFeedback != null && _curFeedback != value)
            {
                _curFeedback.Hide();
            }
            _curFeedback = value;

            
            _curFeedback?.Toggle(player);
        }
    }

    // Update is called once per frame
    void Update()
    {

        Vector3 left = Vector3.zero;
        if (Input.GetKey(leftKey))
        {
            left = Vector3.left;
        }
        else if (Input.GetKey(rightKey))
        {
            left = Vector3.right;
        }

        Vector3 up = Vector3.zero;
        if (Input.GetKey(upKey))
        {
            up = Vector3.up;
        }
        else if (Input.GetKey(downKey))
        {
            up = Vector3.down;
        }

        Vector3 dir = (left + up).normalized;
        transform.position += dir * speed * Time.deltaTime;

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
                //    string dbg = "Root Element: {0} \n GrandChild Element: {1}";
                //Debug.Log(string.Format(dbg, results[results.Count - 1].gameObject.name, results[0].gameObject.name));
                //Debug.Log("Root Element: "+results[results.Count-1].gameObject.name);
                //Debug.Log("GrandChild Element: "+results[0].gameObject.name);
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

        if(curFeedback != null && Input.GetKeyDown(actionKey))
        {
            curFeedback.Activate(player);
        }
        
    }
}
