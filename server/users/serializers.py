from rest_framework import serializers
from .models import UserProfile
from django.contrib.auth.models import User

class UserProfileCreateSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', required=True)
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)

    class Meta:
        model = UserProfile
        fields = ['username', 'first_name', 'last_name', 'email']

    def create(self, validated_data):
        username = validated_data.pop('user')['username']
        user = User.objects.create(username=username)

        user_profile = UserProfile.objects.create(
            user=user,
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name'],
            email=validated_data['email']
        )
        return user_profile
