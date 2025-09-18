import { Stack } from "expo-router";

export default function Layout() {
  return (
    <Stack>
      <Stack.Screen
        name="index"
        options={{
          title: "Settings",
          headerBackButtonDisplayMode: "generic",
        }}
      />
      <Stack.Screen
        name="change-password"
        options={{ title: "Change password", headerBackButtonDisplayMode: "generic" }}
      />
      <Stack.Screen
        name="delete-account"
        options={{ title: "Delete account", headerBackButtonDisplayMode: "generic" }}
      />
      <Stack.Screen
        name="change-email"
        options={{ title: "Change email", headerBackButtonDisplayMode: "generic" }}
      />
    </Stack>
  );
}
