<!-- ���������� ������ ���������� � Web.config -->

<connectionStrings>
    <!-- ��� ��� ����� ������������, �������������� ����������� Windows -->
    <add 
        name="local"
        connectionString="Data Source=localhost;Initial Catalog=tempBase;Integrated Security=SSPI"
        providerName="System.Data.SqlClient"
        />
    <!-- ��� ������ ��� �������, �������������� �� ������ � ������ -->
    <add 
        name="someExternal"
        connectionString="Data Source=192.168.56.22;Initial Catalog=someOtherBase;User ID=vasya;Password=12321;"
        providerName="System.Data.SqlClient"
        />
</connectionStrings>

<!-- ������ ���-�� � ������ �������� �������� ��������� �������� ������ -->

<asp:SqlDataSource
    ID="branchFLsrc"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:local %>"
    SelectCommand = "SELECT * FROM tempBase.dbo.someTable;"
    />

<!-- � ������ ��� ���������� ������ -->
    
<asp:DropDownList
    runat="server"
    ID="branchFL"
    Width="200px"
    DataSourceid="branchFLsrc"
    DataTextField="name"      // ��� ������������ � ������
    DataValueField="code"     // ��� ����� ������������ ��� ������
    />