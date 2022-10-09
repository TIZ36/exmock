# exmock
```elixir
#使用该服务器前需要初始化一些数据

Exmock.AutoGen.gen_user 0, 300
Exmock.AutoGen.create_persist_global_and_alli()



```
a game mocker server for im-erlang by using elixir-maru framework

---
## work flow ##
```text
规定下每个层的返回格式要求

HTTP:
----   API   ----
%{code: resp_code, data: data}

---- service ----
no_panic "service_name", fallback: {:error, "[panic rescued] <> #{inspect(trace}}"} do
{:ok, "success", data}, {:fail, "reason", nil}, {:error, "reason", trace}
end

----   data  ----
集成了cache，所以有值返回该值 -> service_data.trans_out
查询
data: 查询到
nil：没有查询到

增
full_data
:fail

改
updated_data
:fail

删除
:ok
:fail




HTTP-REQ   |                                             | DEMO
        -> | Router                                      | mount Exmock.Switcher.Gmock 
        -> | Switcher(Gmock)                             | mount Exmock.ChatApi           
        -> | apis    (ChatApi)                           | get "chat" -> dispatch_get/dispatch_post -> UserService.get()/post()
        -> | service (Exmock.Service.User)               | get("api", params) -> User`:Api`Repo.`:action`()
        -> | repos   (UserInfoRepo, UserBasicInfoRepo)   | Ecto.Query
        -> DB

ErrorCode: Exmock.Common.ErrorCode
    - ok(data: result)
    - fail(@ecode)

定义Model[CamelCase] 
    -> mix ecto.gen.migration #{table_name} (ModelName的小写snake_case), 并修改filed类型 
    -> mix ecto.migrate
```
---
```aidl
# 删除的设计

defmodule TestMapper do
  use Ezx.Orm.Mapper
  import Ecto.Query, warn: false

  # orMapper to insert into db
  mapper "insert_test_by_id", validator: &__MODULE__.validate_insert_test_by_id/1, params: %TestPo.Test{} = po do
    Exmock.Repo.insert(po)
  end

  mapper "insert_test_by_id_no", params: %TestPo.Test{} = po do
    Exmock.Repo.insert(po)
  end

  def validate_insert_test_by_id(%TestPo.Test{} = input) do
    IO.inspect(input, label: "do validate")
    false
  end
end
                                                    /- feat ------------> rel6.7 --->
dev -----------------------> merge --->-------------->
      \--> rel6.6 -- test --/                       \- no feat-- merge--> rel6.6 --->
                            \-- tag --> v6.6.0
                            
                            
                            
                            
                                                                   tag v6.7.0                        tag v6.7.1                                                                                       
                                                                   /          ---- bugfix ----       /               
                                                                  /          /                 \    /         
                                         ---- rel6.7.x [test_ok]-------------                   ->--
                                        / sprint                                                    \
     develop -------------------->------>------------------------------------------------------------>---->                           
                 \              / merge/     
                  |-- feat1 --->      /
                  \                  /
                   |---- feat2 ----->    
                   
                   
                   
                          
```
---
---
## Getting started
### ecto
#### to use
| - schema-type - | - migration-file - | - type mysql-type - |
|-----------------|--------------------|---------------------|
| :binary         | :blob              | :blob               | 
| :integer(small) | :int               | :int                | 
| :integer(large) | :bigint            | :bigint             | 
| :string(large)  | :string            | :varchar            | 


1. update mysql connection config in config.exs
2. run `mix ecto.create`
3. run `mix ecto.migrate`

### to create new data
1. new data file xx.ex
2. declare your schema 
3. run `mix ecto.gen.migration #{table_name}`
4. edit auto-gen migration file under /priv/data/migrations
5. run `mix ecto.migrate`

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file) or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file) files
- [ ] [Add files using the command line](https://docs.gitlab.com/ee/gitlab-basics/add-file.html#add-a-file-using-the-command-line) or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.lilithgame.com/exbase/exmock.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.lilithgame.com/exbase/exmock/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Automatically merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/index.html)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing(SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!).  Thank you to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README
Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
