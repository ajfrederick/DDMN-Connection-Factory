/** 
 * @name ConnectionFactory
 * 
 * @description This is a factory class that creates instances of PartnerNetworkRecordConnection[s] which, when inserted, is the object that shares a 
 * record to another org via an SF2SF connection. This class can be used throughout SF2SF code to create connection records. 
 * 
 * This class is virtual there by extendable. Sub classes are able to override the getNewConnectionRecord() if necessary.
 * 
 * @author Creed Interactive (Andrew Frederick) 1/14/2021
 */
public virtual without sharing class ConnectionFactory {

/**
* FIELDS
*/

    private static final Id DDMIConnectionId = wv6_ConnectionHelper.getConnectionId('RHSC');

    protected Id[] objIds {
        get {
            if( objIds == null ) objIds = new Id[]{};
            return objIds;
        }
        set;
    }

    protected Id[] sharedIds {
        get {
            if( sharedIds == null ) sharedIds = new Id[]{};
            return sharedIds;
        }
        set;
    }

/**
* CONSTRUCTOR
*/

    public ConnectionFactory( Id[] objIds ){
        this.objIds = objIds;

        // get active connections to verify and prevent creating new connections if there already is one
        for( PartnerNetworkRecordConnection pnrc : getActiveRecordConnections() ) {
            sharedIds.add(pnrc.LocalRecordId);
        }
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
    public virtual PartnerNetworkRecordConnection getNewConnectionRecord( Id localRecordId ){
        if( sharedIds.contains( localRecordId ) ) return null;

        return new PartnerNetworkRecordConnection(
            ConnectionId = DDMIConnectionId,
            LocalRecordId = localRecordId,
            SendClosedTasks = false,
            SendOpenTasks = false,
            SendEmails = false
        );
    }

    /**
     * @name getNewConnectionRecords
     * @description assmebles new connections for objs
     * @param none
     * @return PartnerNetworkRecordConnection[]
     */
    public PartnerNetworkRecordConnection[] getNewConnectionRecords(){
        PartnerNetworkRecordConnection[] newConnections = new PartnerNetworkRecordConnection[]{};

        for( Id objId : objIds ){
            PartnerNetworkRecordConnection newConnection = getNewConnectionRecord( objId );
            
            if( newConnection != null ){
                newConnections.add(newConnection);   
            }
        }

        return newConnections;
    }

/**
* QUERY METHODS
*/

    /**
    * @name getActiveRecordConnections
    * @description queries already established connections
    * @param none
    * @return PartnerNetworkRecordConnection
    */
    private PartnerNetworkRecordConnection[] getActiveRecordConnections(){
        PartnerNetworkRecordConnection[] connections = new PartnerNetworkRecordConnection[]{};

        try {

            connections.addAll([SELECT 
                                Id, 
                                LocalRecordId 
                                    FROM PartnerNetworkRecordConnection 
                                    WHERE LocalRecordId IN :objIds
                                    AND ConnectionId = :DDMIConnectionId]);

        } catch( Exception e ){
            creedint.CreedExceptionHandler handler = new creedint.CreedExceptionHandler(e);
            handler.debug();
        }

        return connections;
    }
}