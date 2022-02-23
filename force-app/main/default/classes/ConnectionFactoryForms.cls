/** 
 * @name ConnectionFactoryForms
 * 
 * @description This is a factory class that creates instances of PartnerNetworkRecordConnection[s] which, when inserted, is the object that shares a 
 * record to another org via an SF2SF connection. This class can be used throughout SF2SF code to create connection records.
 * 
 * This class is an extension of the ConnectionFactory class and is used for sending Forms sepcifically. The instatiated 
 * connection record sends the Form's related attachements as well.
 * 
 * @author Creed Interactive (Andrew Frederick) 1/14/2021
 */
public with sharing class ConnectionFactoryForms extends ConnectionFactory {
   
/**
* CONSTRUCTOR
*/

    public ConnectionFactoryForms( Id[] objIds ) {
        super( objIds );
    }

/**
* ACTION METHODS
*/

    /**
    * @name getNewConnectionRecord
    * @description returns a newly instatiated PartnerNetworkRecordConnection object
    * @param Id localRecordId
    * @return void
    */
    public override PartnerNetworkRecordConnection getNewConnectionRecord( Id localRecordId ){
        if( sharedIds.contains( localRecordId ) ) return null;

        PartnerNetworkRecordConnection newConnection = super.getNewConnectionRecord( localRecordId );
        newConnection.RelatedRecords = 'Attachment';

        return newConnection;
    }
}