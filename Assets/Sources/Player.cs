using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{    // Start is called before the first frame update

    public int playerId = 0;
    public Player opponent = null;
    public List<Power> powers = new List<Power>();

    private int playerFocus = 0;
    private int powerFocus = 0;
    private int optionFocus = 0;

    private int powerCount = 0;

    public KeyCode left = default(KeyCode);
    public KeyCode right = default(KeyCode);
    public KeyCode up = default(KeyCode);
    public KeyCode down = default(KeyCode);
    public KeyCode jump = default(KeyCode);

    private void Awake()
    {
        powers.AddRange(transform.GetComponentsInChildren<Power>());
    }

    void Start()
    {
        powerCount = powers.Count;

        foreach(Power power in powers)
        {
            //
        }

        foreach(Power power in opponent.powers)
        {
            //
        }

        playerFocus = playerId;
    }

    // Update is called once per frame
    public void UpdateInput()
    {
        Keyboard();   
    }

    public void Keyboard ()
    {
        if (Input.GetKeyDown(left))
        {
            optionFocus = (optionFocus == 0 ? 1 : 0);
        }
        else if (Input.GetKeyDown(right))
        {

        }
        else if (Input.GetKeyDown(up))
        {
            powerFocus--;

            if (powerFocus < 0)
                powerFocus = powerCount - 1;
        }
        else if (Input.GetKeyDown(down))
        {
            powerFocus++;

            if (powerFocus >= powerCount)
                powerFocus = 0;
        }
        else if (Input.GetKeyDown(jump))
        {
            
        }
    }
}
