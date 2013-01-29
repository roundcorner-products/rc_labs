<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>rC_Giving__Send_To_Email_Campaign_Active</fullName>
        <field>rC_Giving__Send_To_Email_Campaign__c</field>
        <literalValue>1</literalValue>
        <name>Send To Email Campaign Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>rC_Giving__Send_To_Email_Campaign_Inactive</fullName>
        <field>rC_Giving__Send_To_Email_Campaign__c</field>
        <literalValue>0</literalValue>
        <name>Send To Email Campaign Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>rC_Giving__Send To Email Campaign Active</fullName>
        <actions>
            <name>rC_Giving__Send_To_Email_Campaign_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.rC_Giving__Send_To_Email_Campaign__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>rC_Giving__Send To Email Campaign Inactive</fullName>
        <actions>
            <name>rC_Giving__Send_To_Email_Campaign_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.rC_Giving__Send_To_Email_Campaign__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
