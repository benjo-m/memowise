import { changePassword } from "@/api/auth";
import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import { router } from "expo-router";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { Alert, Text, TextInput, TouchableOpacity, View } from "react-native";

export default function ChangePasswordScreen() {
  const [currentPasswordHidden, setCurrentPasswordHidden] = useState<boolean>(true);
  const [newPasswordHidden, setNewPasswordHidden] = useState<boolean>(true);
  const [passwordConfirmationHidden, setPasswordConfirmationHidden] = useState<boolean>(true);

  const {
    control,
    handleSubmit,
    setError,
    formState: { errors },
  } = useForm({
    defaultValues: {
      currentPassword: "",
      newPassword: "",
      confirmNewPassword: "",
    },
  });

  const onSubmit = async (data: any) => {
    try {
      await changePassword({
        password: data.currentPassword,
        "new-password": data.newPassword,
        "password-confirm": data.confirmNewPassword,
      });

      Alert.alert(
        "Password changed successfully.",
        "",
        [
          {
            text: "OK",
            onPress: () => router.back(),
          },
        ],
        { cancelable: false }
      );
    } catch (err: any) {
      const errorField = err["field-error"][0];
      const errorMessage = err["field-error"][1];

      if (errorField == "password") {
        setError("currentPassword", {
          type: "manual",
          message: errorMessage,
        });
      } else if (errorField == "new-password") {
        setError("newPassword", {
          type: "manual",
          message: errorMessage,
        });
      }
    }
  };

  return (
    <View style={{ flex: 1, margin: 30, justifyContent: "space-between" }}>
      <View style={{ gap: 20 }}>
        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            Current password
          </Text>
          <Controller
            control={control}
            rules={{
              required: "Current password is required",
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <InputWrapper
                leadingIcon={<FontAwesome6 name="lock" size={16} color="orange" />}
                trailingIcon={
                  <TouchableOpacity onPress={() => setCurrentPasswordHidden((prev) => !prev)}>
                    {currentPasswordHidden ? (
                      <FontAwesome5 name="eye" size={20} color={colors.blue} />
                    ) : (
                      <FontAwesome5 name="eye-slash" size={20} color={colors.blue} />
                    )}
                  </TouchableOpacity>
                }
              >
                <TextInput
                  placeholder="Enter your current password"
                  placeholderTextColor={"#c6c6c6ff"}
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={inputStyles.base}
                  secureTextEntry={currentPasswordHidden}
                  returnKeyType="done"
                  onSubmitEditing={handleSubmit(onSubmit)}
                />
              </InputWrapper>
            )}
            name="currentPassword"
          />
          {errors.currentPassword && (
            <Text style={{ marginTop: 5, color: "red" }}>{errors.currentPassword.message}</Text>
          )}
        </View>

        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            New password
          </Text>

          <Controller
            control={control}
            rules={{
              required: "New password is required",
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <InputWrapper
                leadingIcon={<FontAwesome6 name="lock" size={16} color="orange" />}
                trailingIcon={
                  <TouchableOpacity onPress={() => setNewPasswordHidden((prev) => !prev)}>
                    {newPasswordHidden ? (
                      <FontAwesome5 name="eye" size={20} color={colors.blue} />
                    ) : (
                      <FontAwesome5 name="eye-slash" size={20} color={colors.blue} />
                    )}
                  </TouchableOpacity>
                }
              >
                <TextInput
                  placeholder="Enter your new password"
                  placeholderTextColor={"#c6c6c6ff"}
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={inputStyles.base}
                  secureTextEntry={newPasswordHidden}
                  returnKeyType="done"
                  onSubmitEditing={handleSubmit(onSubmit)}
                />
              </InputWrapper>
            )}
            name="newPassword"
          />
          {errors.newPassword && (
            <Text style={{ marginTop: 5, color: "red" }}>{errors.newPassword.message}</Text>
          )}
        </View>

        <View>
          <Text style={{ marginBottom: 8, fontWeight: "600", color: "#2c2c2cff" }}>
            Confirm new password
          </Text>

          <Controller
            control={control}
            rules={{
              required: "Password confirmation is required",
            }}
            render={({ field: { onChange, onBlur, value } }) => (
              <InputWrapper
                leadingIcon={<FontAwesome6 name="lock" size={16} color="orange" />}
                trailingIcon={
                  <TouchableOpacity onPress={() => setPasswordConfirmationHidden((prev) => !prev)}>
                    {passwordConfirmationHidden ? (
                      <FontAwesome5 name="eye" size={20} color={colors.blue} />
                    ) : (
                      <FontAwesome5 name="eye-slash" size={20} color={colors.blue} />
                    )}
                  </TouchableOpacity>
                }
              >
                <TextInput
                  placeholder="Confirm your new password"
                  placeholderTextColor={"#c6c6c6ff"}
                  onBlur={onBlur}
                  onChangeText={onChange}
                  value={value}
                  autoCapitalize="none"
                  autoComplete="off"
                  autoCorrect={false}
                  style={inputStyles.base}
                  secureTextEntry={passwordConfirmationHidden}
                  returnKeyType="done"
                  onSubmitEditing={handleSubmit(onSubmit)}
                />
              </InputWrapper>
            )}
            name="confirmNewPassword"
          />
          {errors.confirmNewPassword && (
            <Text style={{ marginTop: 5, color: "red" }}>{errors.confirmNewPassword.message}</Text>
          )}
        </View>
        <CustomButton
          title={"Change password"}
          color={""}
          onPress={handleSubmit(onSubmit)}
          icon={<FontAwesome name="check" size={18} color="white" />}
        ></CustomButton>
      </View>
    </View>
  );
}
