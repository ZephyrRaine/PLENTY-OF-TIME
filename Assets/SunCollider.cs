using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SunCollider : MonoBehaviour
{
    public Power p;
    public void Update()
    {
        RaycastHit hitInfo;
        if(Physics.Raycast(Camera.main.transform.position, transform.position - Camera.main.transform.position, out hitInfo, 1000f, LayerMask.NameToLayer("PERSO")))
        {
            PlayerAvatar m = hitInfo.transform.GetComponent<PlayerAvatar>();
            if (m != null && Input.GetButtonDown(m.fire))
            {
                p.Launch(m.player, m.player.opponent, 0);
            }

        }

    }
}
