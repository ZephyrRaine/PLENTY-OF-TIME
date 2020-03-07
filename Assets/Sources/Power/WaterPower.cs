public class WaterPower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        target.playerScore.sun = !target.playerScore.sun;
        target.opponent.playerScore.sun = !target.opponent.playerScore.sun;
    }
}