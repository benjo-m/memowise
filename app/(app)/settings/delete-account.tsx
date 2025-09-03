import { closeAccount } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import { useSession } from "@/contexts/auth-context";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import { useState } from "react";
import { ActionSheetIOS, Text, TextInput, TouchableOpacity, View } from "react-native";

export default function DeleteAccountScreen() {
  const [password, setPassword] = useState("");
  const [passwordHidden, setPasswordHidden] = useState<boolean>(true);
  const [passwordErrorVisible, setPasswordErrorVisible] = useState(false);
  const { signOut } = useSession();

  const deleteAccount = async (password: string) => {
    try {
      await closeAccount(password);
      signOut();
    } catch (error) {
      setPasswordErrorVisible(true);
    }
  };

  return (
    <View style={{ flex: 1, margin: 30 }}>
      <View
        style={{
          padding: 20,
          backgroundColor: "#f8d7d7ff",
          borderRadius: 10,
          marginBottom: 20,
        }}
      >
        <View style={{ alignItems: "center", marginBottom: 15 }}>
          <FontAwesome5 name="exclamation-circle" size={32} color="red" />
        </View>
        <Text
          style={{
            textAlign: "center",
            fontWeight: "600",
            color: "red",
          }}
        >
          Deleting your account is permanent and cannot be undone.
        </Text>
        <Text
          style={{
            textAlign: "center",
            fontWeight: "600",
            color: "red",
          }}
        >
          All your data will be erased.
        </Text>
      </View>

      <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
        Enter your password to continue
      </Text>
      <InputWrapper
        leadingIcon={<FontAwesome6 name="lock" size={16} color="orange" />}
        trailingIcon={
          <TouchableOpacity onPress={() => setPasswordHidden((prev) => !prev)}>
            {passwordHidden ? (
              <FontAwesome5 name="eye" size={20} color={colors.blue} />
            ) : (
              <FontAwesome5 name="eye-slash" size={20} color={colors.blue} />
            )}
          </TouchableOpacity>
        }
      >
        <TextInput
          placeholder="Enter your password"
          autoCapitalize="none"
          autoComplete="off"
          autoCorrect={false}
          style={inputStyles.base}
          secureTextEntry={passwordHidden}
          onChangeText={setPassword}
          value={password}
        />
      </InputWrapper>
      {passwordErrorVisible && <Text style={{ marginTop: 5, color: "red" }}>Wrong password</Text>}

      <View style={{ marginTop: 20 }}>
        <CustomButton
          title={"Delete account"}
          color={colors.red}
          onPress={() => {
            ActionSheetIOS.showActionSheetWithOptions(
              {
                title: "Are you sure?",
                message: "Deleting your account is permanent.",
                options: ["Cancel", "Delete Account"],
                destructiveButtonIndex: 1,
                cancelButtonIndex: 0,
              },
              async (buttonIndex) => {
                if (buttonIndex === 1) {
                  await deleteAccount(password);
                }
              }
            );
          }}
          icon={<FontAwesome name="user-times" size={18} color="white" />}
        ></CustomButton>
      </View>
    </View>
  );
}
