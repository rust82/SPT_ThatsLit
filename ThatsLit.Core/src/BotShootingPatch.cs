using SPT.Reflection.Patching;
using HarmonyLib;
using System.Reflection;
using UnityEngine;
using EFT;
using System.Linq;
using SPT.Reflection.Utils;

namespace ThatsLit.Patches.Vision
{
    /// <summary>
    /// SPT 3.11.x compatible bot shooting patch that implements aiming delays and forced misses
    /// This replaces the functionality that was previously in AimingData
    /// </summary>
    public class BotShootingPatch : ModulePatch
    {
        protected override MethodBase GetTargetMethod()
        {
            // Find the bot aiming/shooting method in SPT 3.11.x
            // This targets the method that calculates the end target point for bot shots
            return PatchConstants.EftTypes.First(t => t.GetProperty("LastSpreadCount") != null
                                                   && t.GetProperty("LastAimTime") != null
                                                   && t.GetProperty("HardAim") != null)
                   .GetMethod("get_EndTargetPoint");
        }

        [PatchPostfix]
        public static void PatchPostfix(ref BotOwner ___botOwner_0, ref Vector3 __result)
        {
            if (!ThatsLitPlugin.EnabledMod.Value || !ThatsLitPlugin.EnabledEncountering.Value)
                return;

            if (___botOwner_0?.GetPlayer == null)
                return;

            // Get encounter data for this bot
            var encounterData = EncounteringPatch.GetEncounterData(___botOwner_0.ProfileId);
            if (encounterData == null)
                return;

            ThatsLitPlugin.swEncountering.MaybeResume();

            // Check if bot should delay aiming (reduce accuracy during delay period)
            if (encounterData.ShouldDelayAiming())
            {
                // Add significant spread during aiming delay to simulate bot struggling to acquire target
                float delaySpread = 2.5f * Mathf.InverseLerp(0f, 0.5f, encounterData.AimingDelayUntil - Time.time);
                __result += Random.insideUnitSphere * delaySpread;
            }

            // Check if bot should force miss this shot
            if (encounterData.ShouldForceMiss())
            {
                // Calculate distance to target for scaling miss amount
                float distance = Vector3.Distance(__result, ___botOwner_0.GetPlayer.Position);
                
                // Add spread based on distance - closer targets get smaller misses, far targets get larger misses
                float missSpread = Mathf.Lerp(1.5f, 4.0f, Mathf.InverseLerp(5f, 100f, distance));
                
                // Add some randomization to the miss direction
                Vector3 missDirection = Random.insideUnitSphere;
                missDirection.y *= 0.5f; // Reduce vertical miss component
                
                __result += missDirection * missSpread;
            }

            ThatsLitPlugin.swEncountering.Stop();
        }
    }
}
