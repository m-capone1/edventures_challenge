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
        fields = ['id', 'username', 'first_name', 'last_name', 'email']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create(username=user_data['username'])

        user_profile = UserProfile.objects.create(
            user=user,
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name'],
            email=validated_data['email']
        )
        return user_profile
    
    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)

        if user_data:
            user = instance.user
            user.username = user_data.get('username', user.username)
            user.save()

        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.last_name = validated_data.get('last_name', instance.last_name)
        instance.email = validated_data.get('email', instance.email)
        instance.save()

        return instance
