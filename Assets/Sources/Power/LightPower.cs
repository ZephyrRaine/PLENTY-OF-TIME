public class LightPower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        if (target.playerScore.lightOff == false)
        {
            target.playerScore.lightOff = true;
        }
    }
}