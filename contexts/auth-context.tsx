import { useStorageState } from "@/hooks/useStorageState";
import { SplashScreen } from "expo-router";
import { createContext, use, type PropsWithChildren } from "react";

SplashScreen.preventAutoHideAsync();

type SignInResult = {
  success: boolean;
  error?: string;
};

const AuthContext = createContext<{
  signIn: (email: string, password: string) => Promise<SignInResult> | null;
  signOut: () => void;
  session?: string | null;
  isLoading: boolean;
}>({
  signIn: () => null,
  signOut: () => null,
  session: null,
  isLoading: false,
});

export function useSession() {
  const value = use(AuthContext);
  if (!value) {
    throw new Error("useSession must be wrapped in a <SessionProvider />");
  }

  return value;
}

export function SessionProvider({ children }: PropsWithChildren) {
  const [[isLoading, session], setSession] = useStorageState("session");

  return (
    <AuthContext
      value={{
        signIn: async (email: string, password: string): Promise<SignInResult> => {
          try {
            const response = await fetch("http://localhost:3000/login", {
              method: "POST",
              headers: {
                Accept: "application/json",
                "Content-Type": "application/json",
              },
              body: JSON.stringify({ email, password }),
            });

            if (!response.ok) return { success: false, error: "Invalid credentials" };

            const token = response.headers.get("authorization");

            if (!token) return { success: false, error: "Missing token in response" };

            setSession(token);

            return { success: true };
          } catch (err) {
            console.error("Login error:", err);
            return { success: false, error: "Network or server error" };
          }
        },
        signOut: () => {
          setSession(null);
        },
        session,
        isLoading,
      }}
    >
      {children}
    </AuthContext>
  );
}
