import { useSession } from "@/contexts/auth-context";
import { SplashScreen } from "expo-router";

export function SplashScreenController() {
  const { isLoading } = useSession();

  if (!isLoading) {
    SplashScreen.hideAsync();
  }

  return null;
}
