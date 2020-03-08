using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class FeedbackMoonSun : MonoBehaviour
{
    [ContextMenu("Toggle")]
    public void ToggleAnimation()
    {
        transform.DOLocalRotate(new Vector3(0f,0f,transform.eulerAngles.z * -1f), 2.5f).SetEase(Ease.InOutBounce);
    }

    public void SetLeft(bool l)
    {
        transform.eulerAngles = new Vector3(0f, 0f, 90f*(l?-1f:1f));
    }
}
