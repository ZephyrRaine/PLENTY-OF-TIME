using UnityEngine.Events;

public class Timer
{
    private float _total = 0f;
    private float _step = 0f;

    private float   _duration = 0f;
    private bool    _isLoop = false;
    private float   _tick = 0f;
    private bool    _isTick = false;

    public UnityEvent ticked = new UnityEvent();
    public UnityEvent stoped = new UnityEvent();

    public bool running = false;

    public Timer (float duration, float tick = 0f, bool loop = false)
    {
        _duration = duration;
        _isLoop = loop;

        if (tick > 0f)
        {
            _isTick = true;
        }
    }

    public void Start ()
    {
        running = true;
    }

    public void Stop ()
    {
        running = false;
    }

    public void Update(float deltaTime)
    {
        _total += deltaTime;
        _step += deltaTime;

        if (_step >= _tick)
        {
            ticked.Invoke();
            _step -= _tick;
        }

        if (_total >= _duration)
        {
            _total -= _duration;

            if (_isLoop == false)
            {
                _total = 0f;
                running = false;
            }

            stoped.Invoke();
        }
    }
}
