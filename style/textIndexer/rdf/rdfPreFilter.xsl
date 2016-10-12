<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:parse="http://cdlib.org/xtf/parse"
   xmlns:xtf="http://cdlib.org/xtf"
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   exclude-result-prefixes="#all">
   
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/preFilterCommon.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xml" 
      indent="yes" 
      encoding="UTF-8"/>
   
   <!-- ====================================================================== -->
   <!-- Default: identity transformation                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/*">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- DC Indexing                                                           -->
   <!-- ====================================================================== -->
   

   
   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="get-meta">
      
      <xsl:variable name="meta">
               <xsl:call-template name="get-dc-creator"/>
			   <xsl:call-template name="get-dc-title"/>
               <xsl:call-template name="get-dc-date"/>
				
			   <xsl:call-template name="get-dc-format"/>
			   <xsl:call-template name="get-dc-extent"/>
			   <xsl:call-template name="get-dc-language"/>
			   <xsl:call-template name="get-dc-clan"/>
			   <xsl:call-template name="get-dc-gender"/>
			   <xsl:call-template name="get-dc-tribe"/>
			   <xsl:call-template name="get-dc-matdiv"/>
			   <xsl:call-template name="get-dc-description"/>
			   <xsl:call-template name="get-dc-note"/>
				<xsl:call-template name="get-dc-identifier"/>
				<xsl:call-template name="get-dc-unitid"/>
			   <xsl:call-template name="get-dc-source"/>
			   <xsl:call-template name="get-dc-relation"/>
         <xsl:call-template name="get-dc-see_also"/>
         <xsl:call-template name="get-dc-publisher"/>
         <xsl:call-template name="get-dc-place"/>
               
               
      </xsl:variable>
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <!--<xsl:with-param name="display" select="'dynaxml'"/>-->
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>    
   </xsl:template>
   
   
  <!-- creator -->
   <xsl:template name="get-dc-creator">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:creator">
		 <xsl:for-each select="rdf:Description/dc:creator">
            <creator xtf:meta="true">
               <xsl:value-of select="."/>
            </creator>
			</xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
     
   <!-- title --> 
   <xsl:template name="get-dc-title">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:title">
            <title xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:title"/>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- date -->
   <xsl:template name="get-dc-date">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:date">
            <date xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:date"/>
            </date>
         </xsl:when>
         <xsl:otherwise>
            <date xtf:meta="true">
               <xsl:value-of select="'n.d.'"/>
            </date>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
    
   <!-- type ****SLZ REMOVING THIS *** 03/2015
   <xsl:template name="get-dc-type">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:type">
            <type xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:type"/>
            </type>
         </xsl:when>
         <xsl:otherwise>
            <type xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </type>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>-->
  
   <!-- format -->
   <xsl:template name="get-dc-format">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:format">
            <xsl:for-each select="rdf:Description/dc:format">
               <format xtf:meta="true">
                  <xsl:value-of select="."/>
               </format>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
      <!-- publisher -->
   <xsl:template name="get-dc-publisher">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:publisher">
            <xsl:for-each select="rdf:Description/dc:publisher">
               <publisher xtf:meta="true">
                  <xsl:value-of select="."/>
               </publisher>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
 
    <!-- extent -->
   <xsl:template name="get-dc-extent">
      <xsl:if test="rdf:Description/dc:extent">
            <extent xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:extent"/>
            </extent>
         </xsl:if>
   </xsl:template>
   
   <!-- language -->
    <xsl:template name="get-dc-language">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:language">
            <xsl:for-each select="rdf:Description/dc:language">
               <language xtf:meta="true">
                  <xsl:value-of select="."/>
               </language>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
    <!-- clan -->
    <xsl:template name="get-dc-clan">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:clan">
            <xsl:for-each select="rdf:Description/dc:clan">
               <clan xtf:meta="true">
                  <xsl:value-of select="."/>
               </clan>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
   <!-- gender -->
    <xsl:template name="get-dc-gender">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:gender">
            <xsl:for-each select="rdf:Description/dc:gender">
               <gender xtf:meta="true">
                  <xsl:value-of select="."/>
               </gender>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
    <!-- tribe--> 
   <xsl:template name="get-dc-tribe">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:tribe/text()">
            <xsl:for-each select="rdf:Description/dc:tribe/text()">
               <tribe xtf:meta="true">
                  <xsl:value-of select="."/>
               </tribe>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
 
  
   
   <!-- matdiv -->
<xsl:template name="get-dc-matdiv">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:tribe/dc:matdiv">
            <matdiv xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:tribe/dc:matdiv"/>
            </matdiv>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- description --> 
   <xsl:template name="get-dc-description">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:description">
            <description xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:description"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
    <!-- note -->
   <xsl:template name="get-dc-note">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:note">
            <xsl:for-each select="rdf:Description/dc:note">
               <note xtf:meta="true">
                  <xsl:value-of select="."/>
               </note>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
 
  <!-- identifier -->
   <xsl:template name="get-dc-identifier">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:identifer">
            <xsl:for-each select="rdf:Description/dc:identifer">
               <identifier xtf:meta="true">
                  <xsl:value-of select="."/>
               </identifier>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
   <!-- unitid -->
   <xsl:template name="get-dc-unitid">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:identifier[@type='unitid']">
            <xsl:for-each select="rdf:Description/dc:identifier[@type='unitid']">
               <unitid xtf:meta="true">
                  <xsl:value-of select="."/>
               </unitid>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
 

   
 
   <!-- source -->
   <xsl:template name="get-dc-source">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:source">
            <source xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:source"/>
            </source>
         </xsl:when>
         <xsl:otherwise>
            <source xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </source>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- relation--> 
  <xsl:template name="get-dc-relation">
      
         <xsl:if test="rdf:Description/dc:relation">
            <relation xtf:meta="true">
               <xsl:value-of select="rdf:Description/dc:relation"/>
            </relation>
         </xsl:if>
         
   </xsl:template>
   
     <!-- format -->
   <xsl:template name="get-dc-see_also">
     <xsl:choose>
         <xsl:when test="rdf:Description/dc:see_also">
            <xsl:for-each select="rdf:Description/dc:see_also">
               <see_also xtf:meta="true">
                  <xsl:value-of select="."/>
               </see_also>
            </xsl:for-each>
         </xsl:when>
		 </xsl:choose>
   </xsl:template>
   
     <!-- coverage (place) -->
   <xsl:template name="get-dc-place">
      <xsl:choose>
         <xsl:when test="rdf:Description/dc:coverage">
		 <xsl:for-each select="rdf:Description/dc:coverage">
            <place xtf:meta="true">
               <xsl:value-of select="."/>
            </place>
			</xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
  
   
</xsl:stylesheet>
