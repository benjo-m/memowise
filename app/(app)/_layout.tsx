import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import { Tabs } from "expo-router";

export default function TabLayout() {
  return (
    <Tabs screenOptions={{ tabBarActiveTintColor: "#1273de" }}>
      <Tabs.Screen
        name="(decks)"
        options={{
          headerShown: false,
          title: "Study",
          tabBarIcon: ({ color }) => (
            <FontAwesome6 name="graduation-cap" size={24} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="stats"
        options={{
          headerShown: false,
          title: "Stats",
          tabBarIcon: ({ color }) => (
            <FontAwesome6 name="chart-simple" size={24} color={color} />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          headerShown: false,
          title: "Settings",
          tabBarIcon: ({ color }) => (
            <FontAwesome6 name="gear" size={24} color={color} />
          ),
        }}
      />
    </Tabs>
  );
}
