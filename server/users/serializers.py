from rest_framework import serializers
from .models import UserProfile
from django.contrib.auth.models import User

class UserProfileCreateSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', required=True)
    firstName = serializers.CharField(required=True)
    lastName = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)

    class Meta:
        model = UserProfile
        fields = ['id', 'username', 'firstName', 'lastName', 'email']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create(username=user_data['username'])

        user_profile = UserProfile.objects.create(
            user=user,
            firstName=validated_data['firstName'],
            lastName=validated_data['lastName'],
            email=validated_data['email']
        )
        return user_profile
    
    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)

        if user_data:
            user = instance.user
            user.username = user_data.get('username', user.username)
            user.save()

        instance.firstName = validated_data.get('firstName', instance.firstName)
        instance.lastName = validated_data.get('lastName', instance.lastName)
        instance.email = validated_data.get('email', instance.email)
        instance.save()

        return instance
