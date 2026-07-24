package com.swiftbyte.model;

import java.sql.Timestamp;

public class User {
	private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phoneNumber;
    private String deliveryAddress;
    private String role;
    private Timestamp lastLoginAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public User() {
    	
    }
    
	
	public User(int userId, String fullName, String email, String password, String phoneNumber, String deliveryAddress,
			String role, Timestamp lastLoginAt, Timestamp createdAt, Timestamp updatedAt) {
		super();
		this.userId = userId;
		this.fullName = fullName;
		this.email = email;
		this.password = password;
		this.phoneNumber = phoneNumber;
		this.deliveryAddress = deliveryAddress;
		this.role = role;
		this.lastLoginAt = lastLoginAt;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}


	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public Timestamp getLastLoginAt() {
		return lastLoginAt;
	}
	public void setLastLoginAt(Timestamp lastLoginAt) {
		this.lastLoginAt = lastLoginAt;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public Timestamp getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public User(String fullName, String email, String password, String phoneNumber, String deliveryAddress,
			String role) {
		super();
		this.fullName = fullName;
		this.email = email;
		this.password = password;
		this.phoneNumber = phoneNumber;
		this.deliveryAddress = deliveryAddress;
		this.role = role;
	}
	@Override
	public String toString() {
		return "User [userId=" + userId + ", fullName=" + fullName + ", email=" + email + ", password=" + password
				+ ", phoneNumber=" + phoneNumber + ", deliveryAddress=" + deliveryAddress + ", role=" + role
				+ ", lastLoginAt=" + lastLoginAt + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + "]";
	}

}
